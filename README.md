# PHP-TODO Application Containerization using Docker

1. Download or clone php-todo repository using `wget` or `git clone`
2. Write a dockerfile for php-todo app
3. Create a docker-compose.yml and paste the code below:

```
version: "3.9"
services:
 app:
    build:
      context: .
    container_name: php-website
    restart: unless-stopped
    volumes:
      - app:/php-todo
    ports:
      - "${APP_PORT}:80"
    links:
      - db
    depends_on:
      - db

 db:
    image: mysql/mysql-server:latest
    container_name: php-db-server
    hostname: "${DB_HOSTNAME}"
    restart: unless-stopped
    environment:
      MYSQL_DATABASE: "${DB_DATABASE}"
      MYSQL_USER: "${DB_USERNAME}"
      MYSQL_PASSWORD: "${DB_PASSWORD}"
      MYSQL_ROOT_PASSWORD: "${DB_ROOT_PASSWORD}"
    
    ports:
      - "${DB_PORT}:3306"

    volumes:
      - db:/var/lib/mysql

volumes:
  app:
  db:
  ```




