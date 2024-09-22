
from shared.services.database_service import db
from ..models.cab_ride import CabRide

class CabRideService:
    def get_cab_ride_by_ID_and_startTime(self):
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute("""
                SELECT ID, ride_start_time 
                FROM cab_ride 
                WHERE status != 'cancelled' 
                ORDER BY ride_start_time DESC
            """)
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

    def get_cab_ride_by_all(self, ID):
        query = """
            SELECT ID, shift_id, user_id, ride_start_time, ride_end_time, address_starting_point,
                   ST_X(GPS_starting_point) AS lat_start, ST_Y(GPS_starting_point) AS lon_start,
                   address_destination, ST_X(GPS_destination) AS lat_dest, ST_Y(GPS_destination) AS lon_dest,
                   cancelled_by, price, response, evaluate
            FROM cab_ride
            WHERE ID = %s
        """
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (ID,))
            result = cursor.fetchone()  # Fetch one cab ride by ID
            if result and isinstance(result, dict):  # Ensure result is a dictionary
                return result
            else:
                print("No result found.")
                return None
        except Exception as e:
            print("Error occurred: ", e)
            return None
        finally:
            cursor.close()