from shared.services.database_service import db
from ..models.shift import Shift

class ShiftService():
    def get_shift_by_ID_and_shift_start_time(self):
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute("SELECT ID, shift_start_time FROM Shift ORDER BY shift_start_time DESC")
            result = cursor.fetchall()
            if result:
                return result
            else:
                print("No result found.")
                return None
        except Exception as e:
            print("Error occurred: ", e)
            return None
        finally:
            cursor.close()
            
    def get_shift_by_all(self, ID):
        query = "SELECT * FROM Shift WHERE ID = %s"
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (ID,))
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