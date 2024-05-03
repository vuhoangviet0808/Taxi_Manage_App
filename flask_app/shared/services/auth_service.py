from .database_service import db

class AuthService:
    def authenticate(self, sdt, password):
        query = 'SELECT * FROM account WHERE SDT = %s AND password = %s'
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (sdt, password))
            if(cursor != None):
                result = cursor.fetchone()  
                return result  
        except Exception as e:
            print("Error occurred:", e)
            return None  
        finally:
            cursor.close()  
