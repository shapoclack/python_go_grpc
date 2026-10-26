#!/bin/bash
python3 -m venv /root/venv
/root/venv/bin/pip install --upgrade pip
/root/venv/bin/pip install grpcio grpcio-tools django
/root/venv/bin/python3 -c "import grpc, django; print('Native venv ready! grpc:', grpc.__version__, 'django:', django.__version__)"
