from .database_service import db


class AuthService:
    def authenticate(self, username, password):
        query = 'Select * from account where username = %s AND password = %s'
        result = db.cursor().execute(query, (username, password))

        if result:
            return result.fetchone()
        return None