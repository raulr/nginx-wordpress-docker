#!/bin/bash
set -e

common_post_max_size() {
	if [[ ! "${POST_MAX_SIZE}" =~ ^([0-9]+)([kKmMgG]?)$ ]]; then
		echo >&2 'error: invalid value "'"${POST_MAX_SIZE}"'" for POST_MAX_SIZE environment variable'
		exit 1
	fi

	local VALUE="${BASH_REMATCH[1]}"
	local UNIT="${BASH_REMATCH[2]}"

	# Nginx does not support Gigabyte unit, convert it to Megabytes
	if [ "${UNIT}" == "g" ] || [ "${UNIT}" == "G" ]; then
		VALUE="$(($VALUE * 1024))"
		UNIT="m"
	fi
	POST_MAX_SIZE="${VALUE}${UNIT}"
}

if [ "$1" == nginx ]; then
    : "${POST_MAX_SIZE:=64m}"

    common_post_max_size

    sed -i 's/client_max_body_size *[0-9]\+[kKmM]\?/client_max_body_size '"${POST_MAX_SIZE}"'/' /etc/nginx/conf.d/default.conf
    sed -i 's/upload_max_filesize *= *[0-9]\+[kKmMgG]\?/upload_max_filesize='"${POST_MAX_SIZE}"'/' /etc/nginx/global/wordpress.conf
    sed -i 's/post_max_size *= *[0-9]\+[kKmMgG]\?/post_max_size='"${POST_MAX_SIZE}"'/' /etc/nginx/global/wordpress.conf
fi

exec "$@"