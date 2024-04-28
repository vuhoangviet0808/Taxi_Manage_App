class AuthService:
    def __init__(self):
        self.accounts = {
            "john": "password123",
            "emma" : "password456"
        }
    
    def authenticate(self, username, password):
        if username in self.accounts and self.accounts[username] == password:
            return True
        return False