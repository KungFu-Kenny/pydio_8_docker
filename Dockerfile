#----------------------------------------------------------------

#set the base image

FROM debian
ENV PYDIO_VERSION 8.0.2


#update

RUN apt update -y

#install packages

RUN apt install -y \
tar supervisor wget openssl \
apache2 php php-mcrypt php-intl php-gd php-mysql php-mbstring php-dom libapache2-mod-php \
php-cli


#----------------------------------------------------------------

#define the ENV variable

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



#----------------------------------------------------------------
#configure apache2

RUN a2dissite 000-default.conf
RUN a2ensite pydio.conf
RUN a2enmod rewrite

RUN service apache2 restart

#----------------------------------------------------------------

#configure output_buffering and such

RUN sed -i -e "s/output_buffering\s*=\s*4096/output_buffering = Off/g" /etc/php/7.0/cli/php.ini

#upload php

RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 8G/g" /etc/php/7.0/cli/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 10G/g" /etc/php/7.0/cli/php.ini

#----------------------------------------------------------------

#Pydio booster

ADD pydio-boost-conf /home/pydioconf
ADD pydio-boost-caddy /home/pydiocaddy
ADD pydiobooster /home/pydiobooster
RUN chmod +x /home/pydiobooster


#----------------------------------------------------------------

#expose ports

EXPOSE 80
EXPOSE 443

#----------------------------------------------------------------

#expose volumes

VOLUME [ "/var/www/pydio/data/files/" ]
VOLUME [ "/var/www/pydio/data/personal/" ]
#VOLUME [ "/var/lib/mysql" ]
#VOLUME [ "/var/www/pydio/conf" ]

#----------------------------------------------------------------

#Commands & Entrypoint when you start container

CMD ["supervisord", "-n"]