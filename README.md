# python_go_grpc — Практическая работа №4

## Описание проекта
Проект межсервисного взаимодействия с использованием **gRPC**, **Protocol Buffers**, взаимной аутентификации **mTLS** (Mutual TLS) и обратного прокси-сервера **Nginx**.

- **Сервер:** написан на языке Go (1.22+), реализует сервис `DiceService` (RPC `RollDie`), предоставляет два порта:
  - `127.0.0.1:8443` — защищенное соединение с взаимной TLS-аутентификацией (mTLS);
  - `127.0.0.1:50051` — открытое соединение HTTP/2 (h2c) без TLS.
- **Прокси:** Nginx с поддержкой HTTP/2 и mTLS на портах `9445`/`9448`, проксирующий gRPC-трафик (`grpc_pass`) на внутренний адрес Go-сервера `50051`.
- **Клиент:** веб-приложение на Django (Python), обращающееся к сервису `DiceService` как напрямую через mTLS, так и через прокси Nginx.
- **Сертификаты:** сгенерированы с помощью CloudFlare PKI (`CFSSL`).

---

## Структура проекта
```
python_go_grpc/
├── certs/                      # Сертификаты mTLS и конфигурации CSR
│   ├── ca-config.json          # Конфигурация подписи CA
│   ├── ca-csr.json             # CSR для корневого сертификата CA
│   ├── server-csr.json         # CSR для серверного сертификата
│   ├── client-csr.json         # CSR для клиентского сертификата
│   ├── ca.pem, ca-key.pem      # Корневой сертификат CA и ключ
│   ├── server.pem, server-key.pem # Сертификат сервера и ключ
│   └── client.pem, client-key.pem # Сертификат клиента и ключ
├── certs.sh                    # Скрипт генерации сертификатов через cfssl
├── proto/
│   └── api.proto               # Определение gRPC-сервиса и сообщений
├── client/                     # Клиентское Django-приложение
│   ├── api/
│   │   ├── client.py           # Клиентский gRPC-стаб с загрузкой mTLS сертификатов
│   │   ├── api_pb2.py          # Скомпилированный Protobuf для Python
│   │   └── api_pb2_grpc.py     # Сгенерированные gRPC-классы для Python
│   ├── settings.py             # Настройки Django
│   ├── urls.py                 # Маршруты веб-приложения
│   ├── views.py                # Контроллеры index, grpc, nginx
│   ├── wsgi.py
│   └── asgi.py
├── server/                     # Серверная часть на Go
│   ├── api/
│   │   ├── server.go           # Реализация логики DiceServiceServer
│   │   ├── api.pb.go           # Скомпилированный Protobuf для Go
│   │   └── api_grpc.pb.go      # Сгенерированные gRPC-интерфейсы для Go
│   └── server.go               # Основной файл запуска gRPC-серверов (mTLS и h2c)
├── templates/
│   └── index.html              # HTML-шаблон игры в кости
├── nginx.conf                  # Конфигурация Nginx с mTLS и grpc_pass
├── go.mod, go.sum              # Модули Go
└── manage.py                   # Точка входа Django
```

---

## Запуск проекта

1. **Генерация сертификатов:**
   ```bash
   bash certs.sh
   ```

2. **Запуск сервера Go:**
   ```bash
   go run server/server.go
   ```

3. **Запуск Nginx:**
   ```bash
   nginx -p $(pwd)/ -c $(pwd)/nginx.conf
   ```

4. **Запуск веб-клиента Django:**
   ```bash
   python manage.py runserver 0.0.0.0:8080
   ```

5. **Проверка в браузере:**
   - Главная страница: `http://127.0.0.1:8080/`
   - Прямой вызов gRPC: `http://127.0.0.1:8080/grpc`
   - Вызов через Nginx: `http://127.0.0.1:8080/nginx`
