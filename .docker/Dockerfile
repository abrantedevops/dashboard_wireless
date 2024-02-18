FROM debian:latest

RUN apt-get update && apt-get install -y apache2 iputils-ping dnsutils nano

RUN rm /var/www/html/index.html

RUN mkdir -p /var/www/html/check

COPY apache2.conf /etc/apache2/

RUN chown -R www-data:www-data /var/www/html/check

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]