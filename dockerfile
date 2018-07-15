FROM mediawiki:1.31

MAINTAINER LargoUsagi


RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        g++ libicu-dev zlib1g-dev \
        libxml2-dev libldap2-dev \
        imagemagick

RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/
RUN docker-php-ext-configure intl
RUN docker-php-ext-install ldap xml mbstring intl

RUN a2enmod rewrite
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

RUN apt-get purge -y --auto-remove g++ libicu-dev zlib1g-dev libxml2-dev libldap2-dev \
    && rm -rf /var/lib/apt/lists/* \
 && apt-get clean
