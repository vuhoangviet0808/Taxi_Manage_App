import threading
import time
from flask import current_app, logging
from shared.services.database_service import db
from ..models.user import User, CabRide, Cab, Shift, BookingRequest, Driver


class UserService():
    # Hàm lấy thông tin người dùng dựa trên số điện thoại
    def get_user_by_phone(self, phone):
        query = "Select * from user where SDT = %s"
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (phone,))
            if cursor != None:
                result = cursor.fetchone()
                return result
        except Exception as e:
            print("Error occurred:", e)
            return None  
        finally:
            cursor.close()  

    # Hàm cập nhật thông tin người dùng
    def update_user_info(self, user):
        cursor = db.cursor()
        try:
            if user.gender not in ['Nam', 'Nữ']:
                raise ValueError(f"Invalid gender value: {user.gender}")
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

    # Hàm lấy kiểu xe dựa trên cab_id
    def get_car_model(self, cab_id):
        query = "SELECT car_type FROM Cab WHERE ID = %s"
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (cab_id,))
            result = cursor.fetchone()
            if result:
                return result['car_type']
            else:
                return None
        except Exception as e:
            print("Error: ", e)
            return None
        finally:
            cursor.close()
    # Hàm lấy thông tin chuyến đi dựa trên user_id
    def get_cab_ride(self, user_id):
        query = "SELECT * FROM cab_ride WHERE user_id = %s"
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (user_id,))
            result = cursor.fetchall()
            return [CabRide.from_dict(row) for row in result]
        except Exception as e:
            logging.error(f"Error retrieving cab rides: {e}")
            return None
        finally:
            cursor.close()

    # Hàm gửi yêu cầu đặt xe
    def send_booking_request(self, booking_data):
        # Chuyển đổi tọa độ GPS thành chuỗi WKT cho kiểu POINT
        gps_pick_up_location = f"POINT({booking_data['gps_pickup_location']['longitude']} {booking_data['gps_pickup_location']['latitude']})"
        gps_destination_location = f"POINT({booking_data['gps_destination_location']['longitude']} {booking_data['gps_destination_location']['latitude']})"
    
        query = """
            INSERT INTO booking_requests (
                user_id, requested_car_type, pickup_location, 
                dropoff_location, gps_pick_up_location, 
                gps_destination_location, price, status
            ) VALUES (%s, %s, %s, %s, ST_GeomFromText(%s), ST_GeomFromText(%s), %s, %s)
        """
        cursor = db.cursor()
        try:
            cursor.execute(query, (
                booking_data['user_id'],
                booking_data['requested_car_type'],
                booking_data['pickup_location'],
                booking_data['dropoff_location'],
                gps_pick_up_location,
                gps_destination_location,
                booking_data.get('price', 0.0),
                'pending'
            ))
            db.commit()
            return cursor.lastrowid
        except Exception as e:
            db.rollback()
            print(f"Error occurred while inserting booking request: {e}")
            return None
        finally:
            cursor.close()
    # Hàm lấy booking_id mới nhất dựa trên user_id
    def get_latest_booking_id(self, user_id):
        query = """
            SELECT booking_id 
            FROM booking_requests 
            WHERE user_id = %s 
            ORDER BY request_time DESC 
            LIMIT 1
        """
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (user_id,))
            result = cursor.fetchone()
            if result:
                print(f"Latest booking ID for user_id {user_id}: {result['booking_id']}")
                return result['booking_id']
            else:
                print("No booking found for the given user_id")
                return None
        except Exception as e:
            print(f"Error occurred while retrieving latest booking_id: {e}")
            return None
        finally:
            cursor.close()
# Hàm lấy driver_id dựa trên booking_id
    def get_driver_id_by_latest_booking(self, booking_id):
        query = """
            SELECT driver_id 
            FROM booking_requests 
            WHERE booking_id = %s
        """
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (booking_id,))
            result = cursor.fetchone()
            if result:
                print(f"Driver ID for booking_id {booking_id}: {result['driver_id']}")
                return result['driver_id']
            else:
                print(f"No driver found for the given booking_id {booking_id}")
                return None
        except Exception as e:
            print(f"Error occurred while retrieving driver_id for booking_id {booking_id}: {e}")
            return None
        finally:
            cursor.close()
# Hàm lấy thông tin cab_ride dựa trên driver_id từ booking_request
    def get_cab_ride_by_driver_id_from_db(self, driver_id):
        query = """
            SELECT DISTINCT cr.*
            FROM cab_ride cr
            JOIN shift s ON cr.shift_id = s.ID
            JOIN booking_requests br ON s.Driver_id = br.driver_id
            WHERE br.driver_id = %s
            ORDER BY cr.ID DESC
            LIMIT 1;
        """
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (driver_id,))
            result = cursor.fetchone()
            if result:
                print(f"CabRide found for driver_id {driver_id}: {result}")
                return CabRide.from_dict(result)
            else:
                print(f"No CabRide found for driver_id {driver_id}")
                return None
        except Exception as e:
            print(f"Error occurred while retrieving CabRide for driver_id {driver_id}: {e}")
            return None
        finally:
            cursor.close()
# Hàm cập nhật evaluate (điểm đánh giá) dựa trên ID của cab_ride
    def update_cab_ride_evaluate(self, cab_ride_id, evaluate):
        query = """
            UPDATE cab_ride 
            SET evaluate = %s
            WHERE ID = %s
        """
        cursor = db.cursor()
        try:
            cursor.execute(query, (evaluate, cab_ride_id))
            db.commit()
            print(f"Cab ride with ID {cab_ride_id} successfully updated with evaluate: {evaluate}")
            return cursor.rowcount  # Trả về số hàng đã được cập nhật
        except Exception as e:
            db.rollback()
            print(f"Error occurred while updating evaluate for cab_ride ID {cab_ride_id}: {e}")
            return 0
        finally:
            cursor.close()            
 # Hàm lấy thông tin xe taxi dựa trên driver_id
    def get_cab_by_driver_id(self, driver_id):
        query = """
            SELECT c.*
            FROM shift s
            JOIN cab c ON s.cab_id = c.ID
            JOIN driver d ON s.Driver_id = d.Driver_ID
            WHERE d.Driver_ID = %s
            LIMIT 1;
        """
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (driver_id,))
            result = cursor.fetchone()
            if result:
                print(f"Cab found for driver_id {driver_id}: {result}")
                return Cab.from_dict(result)  # Chuyển đổi kết quả thành object Cab
            else:
                print(f"No cab found for driver_id {driver_id}")
                return None
        except Exception as e:
            print(f"Error occurred while retrieving cab for driver_id {driver_id}: {e}")
            return None
        finally:
            cursor.close()
# Hàm lấy thông tin tài xế dựa trên driver_id
    def get_driver_by_id(self, driver_id):
        query = """
            SELECT * 
            FROM driver 
            WHERE Driver_ID = %s
            LIMIT 1;
        """
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (driver_id,))
            result = cursor.fetchone()
            if result:
                print(f"Driver found for driver_id {driver_id}: {result}")
                return Driver.from_dict(result)  # Chuyển đổi kết quả thành object Driver
            else:
                print(f"No driver found for driver_id {driver_id}")
                return None
        except Exception as e:
            print(f"Error occurred while retrieving driver for driver_id {driver_id}: {e}")
            return None
        finally:
            cursor.close()
# Hàm lấy điểm đánh giá (evaluate) dựa trên driver_id
    def get_evaluate_by_driver_id(self, driver_id):
        query = """
            SELECT evaluate
            FROM shift
            WHERE Driver_id = %s
            LIMIT 1;
        """
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (driver_id,))
            result = cursor.fetchone()
            if result and result['evaluate'] is not None:
                print(f"Evaluate for driver_id {driver_id}: {result['evaluate']}")
                return result['evaluate']  # Trả về giá trị evaluate
            else:
                print(f"No evaluate data found for driver_id {driver_id}")
                return None
        except Exception as e:
            print(f"Error occurred while retrieving evaluate for driver_id {driver_id}: {e}")
            return None
        finally:
            cursor.close()
# Hàm hủy chuyến đi dựa trên user_id và booking_id mới nhất
    def cancel_latest_booking(self, user_id):
        query_select = """
            SELECT booking_id 
            FROM booking_requests 
            WHERE user_id = %s 
            ORDER BY booking_id DESC 
            LIMIT 1
        """
        query_update = """
            UPDATE booking_requests 
            SET status = 'cancelled' 
            WHERE booking_id = %s
        """
        cursor = db.cursor()
        try:
            # Lấy booking_id đầu tiên (nhỏ nhất)
            print(f"Running query to get the first booking for user_id {user_id}")
            cursor.execute(query_select, (user_id,))
            result = cursor.fetchone()
            print(f"Query result: {result}")
        
            if result:
                latest_booking_id = result[0]  # Truy cập phần tử đầu tiên của tuple
                print(f"First booking ID for user_id {user_id} is {latest_booking_id}")
        
                # Cập nhật trạng thái thành 'cancelled'
                print(f"Cancelling booking with ID {latest_booking_id}")
                cursor.execute(query_update, (latest_booking_id,))
                db.commit()
                print(f"Booking with ID {latest_booking_id} has been cancelled.")
                return cursor.rowcount  # Trả về số hàng đã được cập nhật
            else:
                print(f"No booking found for user_id {user_id}")
                return 0
        except Exception as e:
            db.rollback()
            print(f"Error occurred while cancelling the booking for user_id {user_id}: {e}")
            return 0
        finally:
            cursor.close()
