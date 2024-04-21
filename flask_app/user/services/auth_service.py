# auth_service.py

class AuthenticationService:
    def __init__(self):
        # Giả sử chúng ta có một "cơ sở dữ liệu" đơn giản
        self.users = {
            "john": "password123",
            "emma": "password456"
        }

    def authenticate(self, username, password):
        if username in self.users and self.users[username] == password:
            return True
        return False
