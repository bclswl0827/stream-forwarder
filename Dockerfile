# docker build -t live -f Dockerfile .
# docker run -d --name live --restart always -p 8888:80 -v /etc/supervisor/supervisord.conf:/etc/supervisor/conf.d/supervisord.conf live:latest

FROM alpine:latest as builder

COPY ./src /srv
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk add --no-cache --virtual .build-deps go \
    && cd /srv; env CGO_ENABLED=0 GOPROXY=https://goproxy.cn,direct go build -ldflags="-s -w" -o /usr/local/bin/httpd \
    && apk del .build-deps

FROM alpine:latest

LABEL maintainer "Yuki Kikuchi <bclswl0827@yahoo.co.jp>"
COPY --from=builder /usr/local/bin /usr/local/bin
COPY ./rootfs /

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk add --no-cache ffmpeg fdk-aac-dev tini supervisor \
    && chmod 755 /entrypoint.sh \
    && mkdir -p /www

EXPOSE 80
VOLUME ["/www"]
ENTRYPOINT ["/entrypoint.sh"]
