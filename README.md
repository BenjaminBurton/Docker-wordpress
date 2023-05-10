# Docker-wordpress

> Launching a wordpress site has a configuration via their 
[github in the awesome-compose repo]:https://github.com/docker/awesome-compose/tree/master/official-documentation-samples/wordpress/ 

> Below the enviornment for a M1 Mac you have to add platform linux/x86_64 I found the fix from a blog by [catalins.tech]:https://catalins.tech/how-to-run-wordpress-locally-on-macos-with-docker-compose/

```js
services:
  db:
    # We use a mariadb image which supports both amd64 & arm64 architecture
    image: mariadb:10.6.4-focal
    # If you really want to use MySQL, uncomment the following line
    #image: mysql:8.0.27
    command: '--default-authentication-plugin=mysql_native_password'
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=somewordpress
      - MYSQL_DATABASE=wordpress
      - MYSQL_USER=wordpress
      - MYSQL_PASSWORD=wordpress
    expose:
      - 3306
      - 33060
  wordpress:
    image: wordpress:latest
    volumes:
      - wp_data:/var/www/html
    ports:
      - 80:80
    restart: always
    environment:
      - WORDPRESS_DB_HOST=db
      - WORDPRESS_DB_USER=wordpress
      - WORDPRESS_DB_PASSWORD=wordpress
      - WORDPRESS_DB_NAME=wordpress
    platform: linux/x86_64
volumes:
  db_data:
  wp_data:
```