from shared.services.database_service import db
from ..models.booking_request import BookingRequest, FullBookingRequest

class BookingRequestService():
    def get_booking_request_basic(self):
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute("SELECT booking_id, pickup_location,request_time, status FROM booking_requests WHERE status = 'pending' ORDER BY request_time DESC")
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

    
    def get_booking_request_full(self, booking_id):
        query = """
            SELECT 
                booking_id, 
                user_id, 
                requested_car_type, 
                pickup_location, 
                dropoff_location, 
                ST_X(gps_pick_up_location) AS pickup_longitude,
                ST_Y(gps_pick_up_location) AS pickup_latitude,
                ST_X(gps_destination_location) AS destination_longitude,
                ST_Y(gps_destination_location) AS destination_latitude,
                price, 
                request_time, 
                status, 
                driver_id 
            FROM booking_requests 
            WHERE status = 'pending'
            AND
            booking_id = %s
        """
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (booking_id,))
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
    def count_pending_booking_requests(self):
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute("SELECT COUNT(*) AS total_pending FROM booking_requests WHERE status = 'pending'")
            result = cursor.fetchone()
            if result:
                return result['total_pending']
            else:
                print("No pending booking requests found.")
                return 0
        except Exception as e:
            print("Error occurred:", e)
            return 0
        finally:
            cursor.close()


    def count_car_types(self):
        cursor = db.cursor(dictionary=True)
        try:
            query = """
            SELECT 
                requested_car_type, 
                COUNT(*) AS count 
            FROM booking_requests 
            GROUP BY requested_car_type
            """
            cursor.execute(query)
            result = cursor.fetchall()
            
            car_counts = {
                '4_seat': 0,
                '6_seat': 0
            }
            
            for row in result:
                car_type = row['requested_car_type']
                if car_type in car_counts:
                    car_counts[car_type] = row['count']
            
            return car_counts

        except Exception as e:
            print("Error occurred:", e)
            return None
        finally:
            cursor.close()