import logging
from shared.services.database_service import db
from ..models.driver import BookingDriver, Driver, Shift, Cab, CabRide

class DriverService():
    def get_driver_by_phone(self, phone):
        query = """
        SELECT Driver_ID, SDT, Firstname, Lastname, Wallet, DOB, Gender, Address, 
        CCCD, Driving_licence_number, Working_experiment
        FROM driver WHERE SDT = %s
        """
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (phone,))
            result = cursor.fetchone()  # Lấy kết quả
            return result  # Trả về kết quả
        except Exception as e:
            logging.error(f"Error retrieving driver by phone: {e}")
            return None  
        finally:
            cursor.close()  # Đảm bảo đóng con trỏ trong mọi trường hợp

    def update_driver_info(self, driver):
        cursor = db.cursor()
        try:
            cursor.execute("""
                UPDATE driver SET
                Firstname = %s, Lastname = %s, Wallet = %s, DOB = %s, Gender = %s, Address = %s, 
                CCCD = %s, Driving_licence_number = %s, Working_experiment = %s
                WHERE Driver_ID = %s
            """, (
                driver.firstname, driver.lastname, driver.wallet, driver.dob, 
                driver.gender, driver.address, driver.cccd, 
                driver.driving_license, driver.working_experiment, driver.driver_id
            ))
            db.commit()
            return cursor.rowcount
        except Exception as e:
            db.rollback()
            logging.error(f"Error updating driver info: {e}")
            return 0
        finally:
            cursor.close()

    def get_shift(self, driver_id):
        query = """
            SELECT ID, Driver_id, cab_id, ST_AsText(current_gps_location) AS current_gps_location, 
            current_address, evaluate 
            FROM shift WHERE Driver_id = %s
        """
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (driver_id,))
            result = cursor.fetchall()   
            
            if not result:  # Nếu không có kết quả thì trả về danh sách rỗng
                return []

            # Xử lý dữ liệu GPS từ chuỗi "POINT(lat lon)"
            for row in result:
                row['current_gps_location'] = self.parse_gps_location(row['current_gps_location'])

            return [Shift.from_dict(row) for row in result]
        except Exception as e:
            logging.error(f"Error retrieving shifts for driver_id {driver_id}: {e}")
            return None
        finally:
            cursor.close()

    def get_cab_ride(self, driver_id):
        shifts = self.get_shift(driver_id)
        if not shifts:
            return []

        shift_ids = [shift.id for shift in shifts]
        if not shift_ids:
            return []

        format_strings = ','.join(['%s'] * len(shift_ids))
        query = f"""
            SELECT 
                ID, 
                shift_id, 
                user_id, 
                ride_start_time, 
                ride_end_time, 
                address_starting_point, 
                ST_AsText(GPS_starting_point) AS GPS_starting_point, 
                address_destination, 
                ST_AsText(GPS_destination) AS GPS_destination, 
                status, 
                cancelled_by, 
                price, 
                response, 
                evaluate 
            FROM cab_ride 
            WHERE shift_id IN ({format_strings})
            AND status = "completed"
        """
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, tuple(shift_ids))
            result = cursor.fetchall()

            if not result:  # Nếu không có kết quả thì trả về danh sách rỗng
                return []

            # Xử lý các giá trị GPS thành dictionary {'latitude': lat, 'longitude': lon}
            for row in result:
                row['GPS_starting_point'] = self.parse_gps_location(row['GPS_starting_point'])
                row['GPS_destination'] = self.parse_gps_location(row['GPS_destination'])
                
            return [CabRide.from_dict(row) for row in result]
        except Exception as e:
            logging.exception(f"Error retrieving cab rides for driver_id {driver_id}: {e}")
            return None
        finally:
            cursor.close()    

    def parse_gps_location(self, gps_string):
        try:
            if gps_string.startswith("POINT"):
                coords = gps_string[6:-1].split()
                lat, lon = map(float, coords)
                return {"latitude": lat, "longitude": lon}
            return None
        except (ValueError, IndexError) as e:
            logging.error(f"Error parsing GPS location: {e}")
            return None        

    def get_cab(self):
        query = "SELECT * FROM Cab"
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, ())
            result = cursor.fetchall()

            if not result:
                return []

            return [Cab.from_dict(row) for row in result]
        except Exception as e:
            logging.error(f"Error retrieving cabs: {e}")
            return None
        finally:
            cursor.close()
    def post_location(self, driver_id, longitude, latitude, current_address = None):
        query = "UPDATE Shift SET current_gps_location = POINT(%s, %s), current_address = %s WHERE Driver_id = %s"
        cursor = db.cursor(dictionary= True)
        try:
            cursor.execute(query,(longitude, latitude, current_address, driver_id))
            db.commit()
            return cursor.rowcount
        except Exception as e:
            db.rollback()
            logging.error(f"Error updating location for driver_id {driver_id}: {e}")
            return 0
        finally:
            cursor.close()
    def clear_position(self, driver_id):
        query = "UPDATE Shift SET current_gps_location = NULL WHERE Driver_id = %s"
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query,(driver_id,))
            db.commit()
            return cursor.rowcount
        except Exception as e:
            db.rollback()
            logging.error(f"Error clearing position for driver_id {driver_id}: {e}")
            return 0
        finally:
            cursor.close()
    def list_request(self, driver_id):
        query = """
            SELECT 
            bd.booking_id, 
            bd.driver_id, 
            br.pickup_location, 
            br.dropoff_location, 
            ST_X(br.gps_pick_up_location) AS gps_pickup_lat,
            ST_Y(br.gps_pick_up_location) AS gps_pickup_lng,
            ST_X(br.gps_destination_location) AS gps_dropoff_lat,
            ST_Y(br.gps_destination_location) AS gps_dropoff_lng,
            br.price,
            u.SDT AS user_phone
        FROM booking_driver bd
        JOIN booking_requests br ON bd.booking_id = br.booking_id
        JOIN user u ON br.user_id = u.User_ID
        WHERE bd.driver_id = %s AND bd.status = 'pending'
            """
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (driver_id,))
            results = cursor.fetchall()
            logging.info(f"Fetched results: {results}")
            return [BookingDriver.from_dict(row) for row in results]
        except Exception as e:
            logging.error(f"Error fetching bookings for driver_id {driver_id}: {e}")
            return []
        finally:
            cursor.close()
    def accept_booking(self, booking_id, driver_id):
        cursor = db.cursor()
        try:
            logging.info(f"Assigning booking {booking_id} to driver {driver_id}")
        
            # Cập nhật trạng thái booking_request với driver_id và status = 'assigned'
            query1 = """UPDATE booking_requests 
                    SET driver_id = %s, status = 'assigned' 
                    WHERE booking_id = %s"""
            cursor.execute(query1, (driver_id, booking_id))

        # Cập nhật trạng thái trong bảng booking_driver
            query2 = """UPDATE booking_driver 
                    SET status = 'assigned' 
                    WHERE booking_id = %s"""
            cursor.execute(query2, (booking_id,))

        # Thêm thông tin vào bảng cab_ride, sử dụng trực tiếp driver_id làm shift_id
            query3 = """INSERT INTO cab_ride 
                    (shift_id, user_id, ride_start_time, address_starting_point, GPS_starting_point, 
                     address_destination, GPS_destination, status, price)
                    SELECT %s, br.user_id, NOW(), br.pickup_location, br.gps_pick_up_location, 
                           br.dropoff_location, br.gps_destination_location, 'in_progress', br.price
                    FROM booking_requests br
                    WHERE br.booking_id = %s"""
            cursor.execute(query3, (driver_id, booking_id))

            db.commit()
            logging.info(f"Booking {booking_id} assigned to driver {driver_id} and cab_ride entry created")
            return True
        except Exception as e:
            db.rollback()
            logging.error(f"Failed to assign booking {booking_id} and insert cab_ride: {e}")
            return False
        finally:
            cursor.close()

