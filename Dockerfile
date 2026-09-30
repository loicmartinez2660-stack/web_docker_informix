FROM php:7.4-apache

RUN sed -i \
    -e 's/deb.debian.org/archive.debian.org/g' \
    -e 's/security.debian.org/archive.debian.org/g' \
    -e '/bullseye-security/d' \
    /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-11-jre-headless \
        openjdk-11-jdk-headless \
        libzip-dev \
        zip \
        tree \
        tar \
        libelf-dev \
        libncurses6 \
        wget



# 1. Define INFORMIXDIR FIRST so the installer uses the exact path you want
ENV INFORMIXDIR=/opt/IBM/Informix.4.50.FC13W10
ENV PATH=$PATH:$INFORMIXDIR/bin

# 2. Extract and run the installer in silent mode
COPY informix/ibm.csdk.4.50.13.10.Linux.64.x86_64.tar /tmp/csdk.tar
RUN mkdir -p /tmp/csdk $INFORMIXDIR \
    && tar -xf /tmp/csdk.tar -C /tmp/csdk \
    && cd /tmp/csdk \
    && tar -xf ibm.csdk.4.50.13.10.Linux.64.x86_64.tar \
    && ./installclientsdk -i silent -DLICENSE_ACCEPTED=TRUE \
    && rm -rf /tmp/csdk*

# 3. Download, compile, and install PDO_INFORMIX
RUN wget https://pecl.php.net/get/PDO_INFORMIX-1.3.7.tgz \
    && tar -xzf PDO_INFORMIX-1.3.7.tgz \
    && cd PDO_INFORMIX-1.3.7 \
    && phpize \
    && ./configure --with-pdo-informix=$INFORMIXDIR \
    && make \
    && make install 
    # && cd .. && rm -rf PDO_INFORMIX-1.3.7*

# 4. CRITICAL: Enable the extension in PHP config
RUN echo "extension=pdo_informix.so" > /usr/local/etc/php/conf.d/pdo_informix.ini

# 5. Register shared libraries so Linux can find libifgls.so at runtime
RUN echo "$INFORMIXDIR/lib" > /etc/ld.so.conf.d/informix.conf \
    && echo "$INFORMIXDIR/lib/cli" >> /etc/ld.so.conf.d/informix.conf \
    && echo "$INFORMIXDIR/lib/esql" >> /etc/ld.so.conf.d/informix.conf \
    && ldconfig

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf


RUN a2enmod rewrite


EXPOSE 80


CMD ["apache2-foreground"]