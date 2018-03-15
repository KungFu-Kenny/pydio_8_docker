#----------------------------------------------------------------

#set the base image

FROM debian
ENV PYDIO_VERSION 8.0.2


#update

RUN apt update -y

#install packages

RUN apt install -y \
tar supervisor wget openssl zip \
apache2 php php-mcrypt php-intl php-gd php-mysql php-mbstring php-dom libapache2-mod-php php-cli  \
php-memcache php-memcached php-apcu php-imap php-ldap php-opcache php-cli php-xml php-enchant php-redis php-doctrine-cache \
smbclient php-ssh2 clamav clamav-daemon imagemagick unoconv


#----------------------------------------------------------------

#define the ENV variable

#----------------------------------------------------------------

#mailer


#----------------------------------------------------------------



#----------------------------------------------------------------

#Install Pydio

WORKDIR /var/www
RUN wget "https://download.pydio.com/pub/core/archives/pydio-core-8.0.2.tar.gz"
RUN tar -xzf pydio-core-${PYDIO_VERSION}.tar.gz
RUN rm -f pydio-core-${PYDIO_VERSION}.tar.gz
RUN mv pydio-core-${PYDIO_VERSION} pydio
RUN chown -R www-data:www-data /var/www/pydio
RUN chmod -R 770 /var/www/pydio
RUN chmod -R 777 /var/www/pydio/data/files/
RUN chmod -R 777 /var/www/pydio/data/personal/


#----------------------------------------------------------------

#enable virtualhost conf

RUN rm -f /etc/apache2/apache2.conf
ADD apache2.conf /etc/apache2/apache2.conf
ADD pydio-ssl.conf /etc/apache2/sites-available/pydio-ssl.conf
ADD pydio.conf /etc/apache2/sites-available/pydio.conf
ADD apache2-supervisor.conf /etc/supervisor/conf.d/apache2.conf

#----------------------------------------------------------------

#enable SSL conf

RUN a2enmod ssl
RUN mkdir /etc/apache2/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt -subj "/C=FR/ST=FR/L=FR/O=FR/CN=your-pydio.com"
RUN a2ensite pydio-ssl.conf

#----------------------------------------------------------------

#configure apache2

RUN a2dissite 000-default.conf
RUN a2ensite pydio.conf
RUN a2enmod rewrite

RUN service apache2 restart

#----------------------------------------------------------------

#configure output_buffering and such

RUN sed -i -e "s/output_buffering\s*=\s*4096/output_buffering = Off/g" /etc/php/7.0/cli/php.ini
RUN sed -i -e "s/output_buffering\s*=\s*4096/output_buffering = Off/g" /etc/php/7.0/apache2/php.ini


#upload php

RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 4G/g" /etc/php/7.0/cli/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 5G/g" /etc/php/7.0/cli/php.ini

RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 4G/g" /etc/php/7.0/apache2/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 5G/g" /etc/php/7.0/apache2/php.ini

#----------------------------------------------------------------

#Pydio booster

RUN mkdir /home/booster
ADD pydio-boost-conf /home/booster/pydioconf
ADD pydio-boost-caddy /home/booster/pydiocaddy
ADD pydiobooster /home/booster/pydiobooster
RUN chmod +x /home/booster/pydiobooster
#RUN /home/pydiobooster -conf /home/pydioconf

#----------------------------------------------------------------

#expose ports

EXPOSE 80
EXPOSE 443

#----------------------------------------------------------------

#expose volumes

VOLUME [ "/var/www/pydio/data/files/" ]
VOLUME [ "/var/www/pydio/data/personal/" ]
VOLUME [ "/var/www/pydio/conf" ]

#----------------------------------------------------------------

#Commands & Entrypoint when you start container

CMD ["supervisord", "-n"]