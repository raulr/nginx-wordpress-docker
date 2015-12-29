
The [official WordPress image](https://hub.docker.com/_/wordpress/) has a PHP-FPM variant, but it still needs a web server to handle HTTP requests. This image provides an Nginx server ready to use as a `wordpress:fpm` front-end.

The Nginx configuration in this image is based on the guidelines given by the [Wordpress Codex](https://codex.wordpress.org/Nginx).

### How to Use This Image

    $ docker run --name some-nginx --link some-wordpress:wordpress --volumes-from some-wordpress -d -p 8080:80 raulr/nginx-wordpress

### ... via [`docker-compose`](https://github.com/docker/compose)

Example `docker-compose.yml`:

```yaml
wordpress:
  image: wordpress:fpm
  links:
    - db:mysql
nginx:
  image: raulr/nginx-wordpress
  links:
   - wordpress
  volumes_from:
   - wordpress
  ports:
   - "8080:80"
db:
  image: mariadb
  environment:
    MYSQL_ROOT_PASSWORD: example
```

Run `docker-compose up`, wait for it to initialize completely, and visit `http://localhost:8080` or `http://host-ip:8080`.
