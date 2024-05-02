from database_service import db


class AuthService:
    def authenticate(self, username, password):
        quert = 'Select * from account where username = :username AND password = :password'
        result = db.cursor().excute(query, {'username': username, 'password': password})

        account = result.fetchone()

        if account:
            return  account
        return None