import logging
from shared.services.database_service import db
from ..models.driver import Driver, Shift, Cab, CabRide

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
