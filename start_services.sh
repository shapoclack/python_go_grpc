#!/bin/bash
cd /root/python_go_grpc
nginx -p /root/python_go_grpc/ -c /root/python_go_grpc/nginx.conf
nohup ./server_bin > server_run.log 2>&1 &
nohup /root/venv/bin/python3 manage.py runserver 0.0.0.0:8080 --noreload > django_run.log 2>&1 &
sleep 2
ps -ef | grep -E "nginx|server_bin|manage.py"
