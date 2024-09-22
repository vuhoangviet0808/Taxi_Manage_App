import logging
from shared.services.database_service import db
from ..models.driver import CarModel, Driver, Shift, cabModel, CabRide

class DriverService():
    def get_driver_by_phone(self, phone):
        query = "Select * from driver where SDT = %s"
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
            print(f"Error occurred: {e}")
            return 0
        finally:
            cursor.close()

    def get_shift(self, driver_id):
        query = "SELECT * FROM shift WHERE Driver_id = %s"
        cursor = db.cursor(dictionary= True)
        try:
            cursor.execute(query, (driver_id,))
            result = cursor.fetchall()
            return [Shift.from_dict(row) for row in result]
        except Exception as e:
            print("Error: ", e)
            return None
        finally:
            cursor.close()
    def get_car_model(self, car_id):
        query = "SELECT * FROM car_model WHERE ID = %s"
        cursor = db.cursor(dictionary= True)
        try:
            cursor.execute(query, (car_id,))
            result = cursor.fetchone()
            return CarModel.from_dict(result)
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
    def get_cab_ride(self, driver_id):
        shifts = self.get_shift(driver_id)
        if not shifts:
            return None
    
        shift_ids = [shift.id for shift in shifts]
        if not shift_ids:
            return None
        
        format_strings = ','.join(['%s'] * len(shift_ids))
        query = f"SELECT * FROM cab_ride WHERE shift_id IN ({format_strings})"
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, tuple(shift_ids))
            result = cursor.fetchall()
            return [CabRide.from_dict(row) for row in result]
        except Exception as e:
            logging.error(f"Error retrieving cab rides: {e}")
            return None
        finally:
            cursor.close()