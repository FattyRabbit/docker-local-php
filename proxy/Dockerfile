FROM jwilder/nginx-proxy:alpine
MAINTAINER kugyon.i <fatty.rabbit.75@gmail.com>

# Declare Arguments
ARG TZ=Asia/Tokyo

RUN echo "$TZ" > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

#RUN rm -rf /etc/nginx/conf.d/*
RUN { \
    sed -ri 's/include \/etc\/nginx\/conf.d\/\*\.conf/include \/etc\/nginx\/conf.d\/web\.\*\.conf/' /etc/nginx/nginx.conf; \
    # Increased the number of worker_processes from any number to 4
    sed -i 's/\(worker_processes\s*\)[0-9]*;/\14;/' /etc/nginx/nginx.conf; \
    # Increased the number of worker_connections from any number to 19000
    sed -i 's/\(worker_connections\s*\)[0-9]*;/\119000;/' /etc/nginx/nginx.conf; \
}

EXPOSE 80 443