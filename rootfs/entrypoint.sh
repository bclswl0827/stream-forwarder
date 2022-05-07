#!/bin/sh

if [ -f "/usr/bin/tini" ]; then
    echo "Debian detected"
    /usr/bin/tini -s -- supervisord -n -c /etc/supervisor/supervisord.conf &
else
    echo "Alpine detected"
    mkdir -p /etc/supervisor.d
    cp -r /etc/supervisor/conf.d/supervisord.conf /etc/supervisor.d/supervisord.ini
    /sbin/tini -s -- supervisord -n -c /etc/supervisord.conf &
fi

# 启动 HTTP 服务器
if [ $PORT ]; then
    /usr/bin/python3 -m http.server -d /www $PORT --bind ::
else
    /usr/bin/python3 -m http.server -d /www 80 --bind ::
fi
