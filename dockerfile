FROM largousagi/phpapachehost:7.0

MAINTAINER LargoUsagi

ENV MW_BRANCH=REL1_28

RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        git g++ libicu52 libicu-dev zlib1g-dev \
        libxml2-dev libldap2-dev \
        imagemagick

RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/
RUN docker-php-ext-configure intl
RUN docker-php-ext-install ldap xml mbstring intl

RUN apt-get purge -y --auto-remove g++ libicu-dev zlib1g-dev libxml2-dev libldap2-dev \
    && rm -rf /var/lib/apt/lists/* \
 && apt-get clean

RUN git clone -b $MW_BRANCH https://github.com/wikimedia/mediawiki.git /var/www/html

RUN mkdir /var/www/html/vendor
RUN git clone -b $MW_BRANCH https://gerrit.wikimedia.org/r/p/mediawiki/vendor.git /var/www/html/vendor

WORKDIR /var/www/html

COPY apache/mediawiki.conf /etc/apache2/
RUN echo Include /etc/apache2/mediawiki.conf >> /etc/apache2/apache2.conf

CMD ["apache2-foreground"]
