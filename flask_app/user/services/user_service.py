from flask import logging
from shared.services.database_service import db
from ..models.user import User, CabRide, cabModel, Shift, BookingRequest

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
    def get_car_model(self, cab_id):
        query = "SELECT car_type FROM Cab WHERE ID = %s"
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (cab_id,))
            result = cursor.fetchone()
            if result:
                return result['car_type']  # Trả về car_type thay vì object CarModel
            else:
                return None
        except Exception as e:
            print("Error: ", e)
            return None
        finally:
            cursor.close()
    def get_cab(self):
        query = "SELECT * FROM Cab"
        cursor = db.cursor(dictionary= True)
        try:
            cursor.execute(query, ())
            result = cursor.fetchall()
            return [cabModel.from_dict(row) for row in result]
        except Exception as e:
            print("Error: ", e)
            return None
        finally:
            cursor.close()
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
                gps_pick_up_location,  # Sử dụng chuỗi WKT
                gps_destination_location,  # Sử dụng chuỗi WKT
                booking_data.get('price', 0.0),  # Giá có thể để mặc định là 0.0
                'pending'  # Trạng thái ban đầu
            ))
            db.commit()
            return cursor.lastrowid  # Trả về ID của booking mới tạo
        except Exception as e:
            db.rollback()
            print(f"Error occurred while inserting booking request: {e}")
            return None
        finally:
            cursor.close()

