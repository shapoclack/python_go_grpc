#!/bin/bash
export PATH="/root/go/bin:/usr/local/bin:/usr/bin:/bin"
cd /root/python_go_grpc
protoc --go_out=. --go_opt=module=python_go_grpc --go-grpc_out=. --go-grpc_opt=module=python_go_grpc -I proto proto/api.proto
ls -la server/api
