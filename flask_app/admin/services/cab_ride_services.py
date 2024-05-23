from shared.services.database_service import db
from ..models.cab_ride import cab_ride

class Cab_rideService():
    def get_cab_ride_by_ID_and_startTime(self):
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute("SELECT ID, ride_start_time FROM cab_ride WHERE canceled = 0 ORDER BY ride_start_time ASC")
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