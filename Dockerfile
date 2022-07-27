FROM alpine:3.16.0
ARG NGINX_VERSION=1.23.1
ARG NGINX_HTTP_FLV_MODULE_VERSION=1.2.10

WORKDIR /nginx

RUN apk add --no-cache \
    build-base \
    ca-certificates \
    curl \
    gcc \
    libc-dev \
    libgcc \
    linux-headers \
    make \
    musl-dev \
    openssl \
    openssl-dev \
    pcre \
    pcre-dev \
    pkgconf \
    pkgconfig \
    zlib-dev

RUN wget https://github.com/winshining/nginx-http-flv-module/archive/refs/tags/v${NGINX_HTTP_FLV_MODULE_VERSION}.tar.gz \
    && tar -zxvf v${NGINX_HTTP_FLV_MODULE_VERSION}.tar.gz \
    && rm -rf v${NGINX_HTTP_FLV_MODULE_VERSION}.tar.gz

RUN  wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
    && tar -zxvf nginx-${NGINX_VERSION}.tar.gz \
    && cd nginx-${NGINX_VERSION} \
    && ./configure --add-module=/nginx/nginx-http-flv-module-${NGINX_HTTP_FLV_MODULE_VERSION} \
    && make \
    && make install

COPY ./nginx.conf /usr/local/nginx/conf/nginx.conf

ENV PATH "${PATH}:/usr/local/nginx/sbin"

CMD ["nginx", "-g", "daemon off;"]