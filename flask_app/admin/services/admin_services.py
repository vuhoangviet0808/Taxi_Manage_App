from shared.services.database_service import db
from ..models.driver import Driver

class AdminService():
    def get_driver_by_name_and_cccd(self):
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute("SELECT Firstname, Lastname, Driver_ID FROM Driver")
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

    def get_driver_by_all(self, Driver_ID):
        query = "SELECT * FROM Driver WHERE Driver_ID = %s"
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (Driver_ID,))
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