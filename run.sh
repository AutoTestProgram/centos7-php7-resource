#!/bin/bash

basedir=/centos7-php7-resource

yum -y install gcc gcc-c++ apr-devel apr-util-devel libtool autoconf automake perl-devel perl-ExtUtils-Embed GeoIP GeoIP-devel make cmake
#openssl
tar -zxvf openssl-1.0.2h.tar.gz
cd ${basedir}/openssl-1.0.2h && ./config -fPIC --prefix=/usr/local/openssl enable-shared
make && make install
#nghttp2
cd ${basedir}
git clone https://github.com/tatsuhiro-t/nghttp2.git
cd ${basedir}/nghttp2 && autoreconf -i && automake && autoconf
./configure --prefix=/usr/local/nghttp2 && make && make install 
#curl
cd ${basedir}
tar -zxvf curl-7.44.0.tar.gz
cd ${basedir}/curl-7.44.0 && env LDFLAGS=-R/usr/local/openssl/lib
echo "/usr/local/nghttp2/lib" > /etc/ld.so.conf.d/nghttp2.conf && ldconfig
./configure --prefix=/usr/local/curl --with-nghttp2=/usr/local/nghttp2 --with-ssl=/usr/local/openssl && make && make install
/usr/bin/mv /usr/bin/curl /usr/bin/curl_bak
/usr/bin/ln -s /usr/local/curl/bin/curl /usr/bin/curl
/usr/bin/ln -s /usr/local/openssl/lib/libssl.so.1.0.0 /usr/lib64/libssl.so.1.0.0
/usr/bin/ln -s /usr/local/openssl/lib/libcrypto.so.1.0.0 /usr/lib64/libcrypto.so.1.0.0
#libiconv
cd ${basedir}
tar -zxvf libiconv-1.14.tar.gz
cd ${basedir}/libiconv-1.14
./configure --prefix=/usr/local/libiconv && sed -i 698d srclib/stdio.in.h
make && make install 
#libxml2
cd ${basedir}
tar -zxvf libxml2-2.9.0.tar.gz
cd ${basedir}/libxml2-2.9.0
sed -i 17035d configure
./configure --prefix=/usr/local/libxml2 && make && make install
#libxslt
cd ${basedir}
tar -zxvf libxslt-1.1.28.tar.gz
cd ${basedir}/libxslt-1.1.28
sed -i 15644d configure
./configure --prefix=/usr/local/libxslt --with-libxml-prefix=/usr/local/libxml2 && \
make && make install
#libmcrypt
cd ${basedir}
tar -zxvf libmcrypt-2.5.8.tar.gz
cd ${basedir}/libmcrypt-2.5.8
./configure && make && make install
#jpeg
cd ${basedir}
tar -zxvf jpegsrc.v9.tar.gz
cd ${basedir}/jpeg-9
./configure --prefix=/usr/local/jpeg9 --enable-shared --enable-static && \
make && make install
#zlib
cd ${basedir}
tar -zxvf zlib-1.2.7.tar.gz &&\
cd zlib-1.2.7 &&\
./configure && \
make && make install
#libpng
cd ${basedir}
tar -zxvf libpng-1.6.0.tar.gz &&\
cd libpng-1.6.0 &&\
cp scripts/makefile.linux makefile>./configure &&\
./configure && \
make && make install
#freetype
cd ${basedir}
tar -zxvf freetype-2.4.0.tar.gz &&\
cd freetype-2.4.0 &&\
./configure --prefix=/usr/local/freetype && \
make && make install
#fontconfig
cd ${basedir}
tar -zxvf fontconfig-2.10.2.tar.gz &&\
cd fontconfig-2.10.2 &&\
export PKG_CONFIG_PATH=/usr/local/freetype/lib/pkgconfig:$PKG_CONFIG_PATH &&\
export PKG_CONFIG_PATH=/usr/local/libxml2/lib/pkgconfig:$PKG_CONFIG_PATH &&\
./configure --prefix=/usr/local/fontconfig --with-libiconv=/usr/local/libiconv -enable-libxml2 && \
make && make install
#gd
cd ${basedir}
tar -zxvf gd-2.0.35.tar.gz && cd gd/2.0.35 &&\
./configure --prefix=/usr/local/gd --with-jpeg=/usr/local/jpeg9 --with-png --with-freetype=/usr/local/freetype --with-fontconfig=/usr/local/fontconfig && \
make && make install
#gd2 library
cd ${basedir}
tar -zxvf libgd-gd-libgd-9f0a7e7f4f0f.tar.gz &&\
cd libgd-gd-libgd-9f0a7e7f4f0f &&\
cmake . 
make && make install
#pcre
cd ${basedir}
tar -zxvf pcre-8.32.tar.gz &&\
cd pcre-8.32 &&\
./configure && make && make install 
#libevent
cd ${basedir}
tar -zxvf libevent-2.0.21-stable.tar.gz &&\
cd libevent-2.0.21-stable &&\
./configure && make && make install 
#mhash
cd ${basedir}
tar -zxvf mhash-0.9.9.9.tar.gz &&\
cd mhash-0.9.9.9 &&\
./configure && make && make install
ln -s /usr/local/lib/libmhash.a /usr/lib64/libmhash.a
ln -s /usr/local/lib/libmhash.la /usr/lib64/libmhash.la
ln -s /usr/local/lib/libmhash.so /usr/lib64/libmhash.so
ln -s /usr/local/lib/libmhash.so.2 /usr/lib64/libmhash.so.2
ln -s /usr/local/lib/libmhash.so.2.0.1 /usr/lib64/libmhash.so.2.0.1
#libunwind
cd ${basedir}
tar -zxvf libunwind-1.1.tar.gz &&\
cd libunwind-1.1 &&\
./configure CFLAGS=-fPIC
make CFLAGS=-fPIC && make CFLAGS=-fPIC install
#gperftools
cd ${basedir}
tar -zxvf gperftools-2.1.tar.gz &&\
cd gperftools-2.1 &&\
./configure --enable-frame-pointers
make && make install
echo "/usr/local/lib" > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig
#php7
php7=${basedir}/php-7.0.10
phpDir=/usr/local/php
cfile=/usr/local/php/etc
phpini=/usr/local/php/etc/php.ini 
cd ${basedir}
tar -zxvf php-7.0.10.tar.gz &&\
cd php-7.0.10 &&\
./configure --prefix=/usr/local/php \
--with-config-file-path=/usr/local/php/etc --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd \
--with-iconv --with-freetype-dir=/usr/local/freetype --with-jpeg-dir=/usr/local/jpeg9 \
--with-png-dir=/usr/local/lib --with-zlib-dir=/usr/local/lib \
--with-libxml-dir=/usr/local/libxml2 \
--with-curl=/usr/local/curl/ --with-mcrypt \
--with-gd --with-openssl=/usr/local/openssl --with-mhash \
--with-xmlrpc --with-xsl=/usr/local/libxslt --enable-xml --enable-bcmath \
--enable-shmop --enable-sysvsem --enable-inline-optimization --enable-mbregex \
--enable-fpm --enable-mbstring --enable-pcntl --enable-sockets --enable-zip --enable-debug \
--enable-ftp --enable-soap --enable-exif --enable-opcache
make && make install
cp ${php7}/php.ini-production ${cfile}/php.ini
ln -s ${phpDir}/bin/php /usr/bin/
ln -s ${phpDir}/bin/php-config /usr/bin/
ln -s ${phpDir}/bin/phpize /usr/bin/
ln -s ${phpDir}/sbin/php-fpm /usr/sbin/
ln -s ${phpDir}/etc/php.ini /etc/
cp ${cfile}/php-fpm.conf.default ${cfile}/php-fpm.conf
cp -r ${php7}/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm
echo -e '\nexport PATH=${phpDir}/bin:${phpDir}/sbin:$PATH\n' >> /etc/profile && source /etc/profile
cp ${cfile}/php-fpm.d/www.conf.default ${cfile}/php-fpm.d/www.conf
sed -i 's/\; short_open_tag/short_open_tag/g' $phpini
sed -i '850 i zend_extension=opcache.so\nopcache.memory_consumption=128\nopcache.interned_strings_buffer=8\nopcache.max_accelerated_files=4000\nopcache.revalidate_fre
q=60\nopcache.fast_shutdown=1\nopcache.enable_cli=1' $phpini

#Nginx install
Nginx=${basedir}/nginx-1.11.3
Ndir=/usr/local/nginx
Nsystmp=/usr/local/nginx/system/temp
Nconf=/usr/local/nginx/etc/nginx.conf
Nerror=/var/log/nginx/error.log
Naccess=/var/log/nginx/access.log
Npid=${Ndir}/system/nginx.pid
Nlock=${Ndir}/system/lock/nginx
Cbody=${Nsystmp}/client_body
Proxy=${Nsystmp}/proxy
Fastcgi=${Nsystmp}/fastcgi
cd ${basedir}
tar -zxvf nginx-1.11.3.tar.gz &&\
cd nginx-1.11.3 &&\
./configure --user=nginx --group=nginx --prefix=${Ndir} \
--sbin-path=${Ndir} --conf-path=${Nconf} --error-log-path=${Nerror} \
--http-log-path=${Naccess} --pid-path=${Npid} \
--lock-path=${Nlock} \
--http-client-body-temp-path=${Cbody} \
--http-proxy-temp-path=${Proxy} \
--http-fastcgi-temp-path=${Fastcgi} \
--with-http_ssl_module --with-http_realip_module \
--with-http_addition_module --with-http_sub_module \
--with-http_dav_module --with-http_flv_module \
--with-http_gzip_static_module --with-http_stub_status_module \
--with-mail --with-mail_ssl_module --with-pcre \
--with-pcre=${basedir}/pcre-8.32 \
--with-zlib=${basedir}/zlib-1.2.7 \
--with-openssl=${basedir}/openssl-1.0.2h \
--with-google_perftools_module \
--with-http_v2_module
make 
make install 
mkdir -p /usr/local/nginx/system/temp/client_body
ln -s /usr/local/nginx/nginx /usr/bin/nginx

#php redis
cd ${basedir}
unzip phpredis-php7.zip
cd phpredis-php7
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install
echo -e 'extension=redis.so\n' >> /usr/local/php/etc/php.ini

#php memcached
cd ${basedir}
tar -zxvf libmemcached-1.0.18.tar.gz
cd libmemcached-1.0.18
./configure --prefix=/usr/local/libmemcached
make && make install
cd ${basedir}
unzip php-memcached-php7.zip
cd php-memcached-php7
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config --with-libmemcached-dir=/usr/local/libmemcached
make && make install
echo -e 'extension=memcached.so\n' >> /usr/local/php/etc/php.ini

#php mongodb
cd ${basedir}
git clone https://github.com/mongodb/mongo-php-driver
cd mongo-php-driver
git submodule update --init
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install
echo -e 'extension=mongodb.so\n' >> /usr/local/php/etc/php.ini

#php ssdb
cd ${basedir}
unzip phpssdb-php7.zip
cd phpssdb-php7
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install
echo -e 'extension=ssdb.so\n' >> /usr/local/php/etc/php.ini

#swoole
cd ${basedir}
git clone https://github.com/swoole/swoole-src.git
cd swoole-src
/usr/bin/phpize
./configure --with-php-config=/usr/bin/php-config 
make && make install
echo -e 'extension=swoole.so\n' >> /usr/local/php/etc/php.ini

#runkit 7
cd ${basedir}
git clone https://github.com/runkit7/runkit7.git
cd runkit7
/usr/bin/phpize
./configure --with-php-config=/usr/bin/php-config
make && make install
echo -e 'extension=runkit.so\n' >> /usr/local/php/etc/php.ini

#yum -y remove gcc libtool autoconf automake make cmake
















