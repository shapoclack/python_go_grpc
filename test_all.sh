#!/bin/bash
cd /root/python_go_grpc
source venv/bin/activate

echo "1. Starting Go gRPC server..."
./server_bin &
GO_PID=$!
sleep 2

echo "2. Starting Nginx..."
nginx -p "$(pwd)/" -c "$(pwd)/nginx.conf"
sleep 2

echo "3. Starting Django client on port 8080..."
python manage.py runserver 0.0.0.0:8080 &
DJANGO_PID=$!
sleep 3

echo "4. Testing HTTP GET / on Django (port 8080)..."
curl -s http://127.0.0.1:8080/ | grep -o "🎲.*🎲" || echo "GET / completed"

echo "5. Testing HTTP POST / (rolling dice)..."
# Get CSRF token first
CSRF_TOKEN=$(curl -s -c cookies.txt http://127.0.0.1:8080/ | grep -o 'name="csrfmiddlewaretoken" value="[^"]*"' | head -n 1 | cut -d'"' -f4)
echo "CSRF token: $CSRF_TOKEN"

POST_RESULT=$(curl -s -b cookies.txt -d "csrfmiddlewaretoken=$CSRF_TOKEN" -X POST http://127.0.0.1:8080/)
echo "$POST_RESULT" | grep -A 2 -B 2 "dice"

echo "6. Testing /grpc endpoint..."
curl -s http://127.0.0.1:8080/grpc
echo ""

echo "7. Testing /nginx endpoint..."
curl -s http://127.0.0.1:8080/nginx
echo ""

echo "Stopping services..."
kill $DJANGO_PID 2>/dev/null
kill $GO_PID 2>/dev/null
nginx -s stop -p "$(pwd)/" -c "$(pwd)/nginx.conf" 2>/dev/null
echo "All done!"
