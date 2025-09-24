FROM nginx:1.23.1-alpine

WORKDIR /app

COPY ./web /app
# Копируем сгенерированные файлы Flutter в стандартную директорию NGINX
COPY ./web /usr/share/nginx/html

EXPOSE 6500