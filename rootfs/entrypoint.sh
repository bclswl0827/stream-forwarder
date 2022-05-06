#!/bin/bash

/usr/bin/python3 -m http.server -d /www 80 --bind :: &
/usr/bin/tini -s -- supervisord -n -c /etc/supervisor/supervisord.conf
