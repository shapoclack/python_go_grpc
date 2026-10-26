#!/bin/bash
killall server_bin 2>/dev/null
pkill -f "manage.py" 2>/dev/null
nginx -s stop -p /root/python_go_grpc/ -c /root/python_go_grpc/nginx.conf 2>/dev/null
sleep 1
echo "Services stopped"
