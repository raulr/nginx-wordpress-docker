FROM nginx:latest

COPY default.conf /etc/nginx/conf.d/default.conf
COPY wordpress.conf /etc/nginx/global/wordpress.conf
COPY restrictions.conf /etc/nginx/global/restrictions.conf
COPY proxy.conf /etc/nginx/global/proxy.conf
COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]