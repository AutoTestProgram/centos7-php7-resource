#!/bin/bash
tar -zxvf openssl-1.0.2h.tar.gz
cd openssl-1.0.2h
./config -fPIC --prefix=/usr/local/openssl enable-shared
make && make install
