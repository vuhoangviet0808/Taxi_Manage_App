from shared.services.database_service import db


class UserService():
    def get_user_by_phone(self, phone):
        query = "Select * from user where SDT = %s"
        cursor = db.cursor(dictionary = True)
        try:
            cursor.execute(query, (phone,))
            if(cursor != None):
                result = cursor.fetchone()
                return result
        except Exception as e:
            print("Error occurred:", e)
            return None  
        finally:
            cursor.close()  