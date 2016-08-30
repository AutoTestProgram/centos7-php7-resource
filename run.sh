#!/bin/bash
yum -y install gcc gcc-c++ apr-devel apr-util-devel libtool autoconf automake libaio perl-devel perl-ExtUtils-Embed GeoIP GeoIP-devel make cmake ntpdate
tar -zxvf openssl-1.0.2h.tar.gz
cd openssl-1.0.2h
./config -fPIC --prefix=/usr/local/openssl enable-shared
make && make install
