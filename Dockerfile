# docker build -t live .
# docker run -d --name live --restart always -p 8888:80 -v /etc/supervisor/supervisord.conf:/etc/supervisor/conf.d/supervisord.conf live:latest

FROM debian:bullseye-slim

LABEL maintainer "Yuki Kikuchi <bclswl0827@yahoo.co.jp>"
COPY rootfs /

RUN apt-get update \
    && apt-get install --no-install-recommends -y ffmpeg libfdk-aac-dev python3 tini supervisor \
    && chmod 755 /entrypoint.sh \
    && mkdir -p /www \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 80
VOLUME ["/www"]
ENTRYPOINT ["/entrypoint.sh"]
