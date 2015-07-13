#! /bin/bash

# Download, build and install Nginx

apt-get update
apt-get install build-essential libpcre3 libpcre3-dev libssl-dev -y
wget http://nginx.org/download/nginx-1.8.0.tar.gz
wget https://github.com/arut/nginx-rtmp-module/archive/master.zip
tar -zxvf ./nginx-1.8.0.tar.gz
unzip ./master.zip
cd ./nginx-1.8.0
./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-master
make
make install

# Configure rtmp module

echo 'rtmp {\n        server {\n                listen 1935;\n                chunk_size 4096;\n
                application live {\n                        live on;\n                        record off;\n                }\n       }
}\n' >> /usr/local/nginx/conf/nginx.conf

# start server

/usr/local/nginx/sbin/nginx

#install rtmpdump, ffmpeg

apt-get install ffmpeg -y