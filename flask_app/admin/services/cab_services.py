from shared.services.database_service import db
from ..models import cab

class CabService:
    def get_cab_by_ID_and_licence_plate(self):
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute("SELECT ID, licence_plate FROM Cab")
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

    def get_cab_by_all(self, ID):
        query = """
        SELECT *
        FROM 
            Cab 
        WHERE 
            Cab.ID = %s
        """
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (ID,))
            result = cursor.fetchall()
            print("Query executed. Result:", result)  # Dòng in ra để debug
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