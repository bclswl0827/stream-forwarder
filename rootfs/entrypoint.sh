#!/bin/sh

sed -i "s/user=root/user=$(whoami)/g" /etc/supervisor/conf.d/supervisord.conf

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
    /usr/local/bin/httpd -p $PORT
else
    /usr/local/bin/httpd -p 80
fi
