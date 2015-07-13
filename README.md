# RTMP Restreamer

A simple solution that should allow a website operator to ingest an IP-locked live stream (using an appropriate security token), then output a non-locked stream that can be embedded on a web page. Currently compatible with Ubuntu server (use the restreamer-ubuntu-14.04.sh setup script for that version).

## Install and configure the server

In order to start restreaming live video from your own server, you'll have to set up and install a few things first. If you want to get started as quickly as possible, use the setup script provided as detailed in option one. Otherwise, if you want full control over the process, work through the steps detailed in option two.

### Use setup script (OPTION 1)

Download the appropriate sh file for the OS version you're running, then run the following command:

    $ sudo sh restreamer-*.sh

### Manual install (OPTION 2)

The server part of the setup is Nginx. This will serve our RTMP streams on port 1935, through an application called 'live'.

1: Build Nginx along with RTMP module:

    $ wget http://nginx.org/download/nginx-1.8.0.tar.gz  
    $ wget https://github.com/arut/nginx-rtmp-module/archive/master.zip  
    $ tar -zxvf nginx-1.8.0.tar.gz  
    $ unzip master.zip  
    $ cd nginx-1.8.0  
    $ ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-master  
    $ make  
    $ sudo make install  

2: Add following to /usr/local/nginx/conf/nginx.conf:
<pre><code> 
rtmp {
        server {
                listen 1935;
                chunk_size 4096;
                
                application live {
                        live on;
                        record off;
                }
        }
}
</pre></code>

3: Start server:

    $ sudo /usr/local/nginx/sbin/nginx

## Ingest and output live stream

We will use two pieces of software to ingest our live stream and push it out to the server so we can broadcast.

RTMPdump: Grabs stream data from RTMP url. We're using RTMPdump since it deals very well with token-based authentication.

FFmpeg: Pipes stream data out in an FLV container to server.

1: Install ffmpeg

This is done by the install script, if you used it, but if you set it up manually:

    $ sudo apt-get install ffmpeg

2: Run following command for each required stream:

    $ rtmpdump -v -r "rtmp://LINK_WITH_TOKEN" | ffmpeg -re -i - -c copy -f flv rtmp://localhost/live/STREAM_NUMBER

LINK_WITH_TOKEN is the rtmp part of the live link you were given, along with the authentication token. It should look something like rtmp://xxxxxx.net/.../stream?6_A_sBUeIdeGER4...

STREAM_NUMBER is an identifier of your choice you can use to identify the final stream. Be sure to pick a unique name, since when serving multiple streams you need to be able to choose which one you want to embed.

## Embed the live stream

You can now take your restreamed RMTP stream from 'rtmp://MY_SERVER_IP/live/STREAM_NUMBER' and drop it into jwplayer or similar in order to view/embed the stream.

Replace MY_SERVER_IP with the public IP address of the server which is running Nginx, and STREAM_NUMBER with the number defined in the previous step.
