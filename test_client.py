import sys
from client.api.client import Certs, Client

try:
    crt = Certs('certs/ca.pem', 'certs/client.pem', 'certs/client-key.pem')

    val_direct = Client('127.0.0.1:8443', crt).roll_die()
    print(f"Direct gRPC (8443) -> RollDie returned: {val_direct}")

    val_nginx = Client('127.0.0.1:9445', crt).roll_die()
    print(f"Nginx proxy (9445) -> RollDie returned: {val_nginx}")

    val_nginx2 = Client('127.0.0.1:9448', crt).roll_die()
    print(f"Nginx proxy (9448) -> RollDie returned: {val_nginx2}")

    print("ALL TESTS PASSED SUCCESSFULLY!")
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
