from shared.services.database_service import db
from ..models.user import User

class UserService():
    def get_user_by_ID_and_name(self):
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute("SELECT Firstname, Lastname, User_ID FROM User")
            result = cursor.fetchall()
            if result:
                return result
            else:
                print("No results found.")
                return None
        except Exception as e:
            print("Error occurred:", e)
            return None  
        finally:
            cursor.close()

    def get_user_by_all(self, User_ID):
        query = "SELECT User.User_ID, User.SDT, User.Firstname, User.Lastname, User.Wallet, User.DOB, User.Gender, User.Address, User.CCCD, Account.created_at FROM User INNER JOIN Account ON User.SDT = Account.SDT WHERE User_ID = %s"
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (User_ID,))
            result = cursor.fetchall()
            if result:
                return result
            else:
                print("No results found")
                return None
        except Exception as e:
            print("Error occurred:", e)
            return None
        finally:
            cursor.close()
