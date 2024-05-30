from shared.services.database_service import db
from ..models.user import User

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
    def update_user_info(self,user):
        cursor = db.cursor()
        try:
            print(f"Updating user with ID {user.user_id}: {user.firstname}, {user.lastname}, {user.gender}, etc.")
            cursor.execute("""
                UPDATE user SET
                Firstname = %s, Lastname = %s, DOB = %s, Gender = %s, Address = %s,
                CCCD = %s
                WHERE User_ID = %s
            """, (
                user.firstname, user.lastname, user.dob, 
                user.gender, user.address, user.cccd, 
                user.user_id
            ))
            db.commit()
            return cursor.rowcount
        except Exception as e:
            db.rollback()
            print(f"Error occurred: {e}")
            return 0
        finally:
            cursor.close()