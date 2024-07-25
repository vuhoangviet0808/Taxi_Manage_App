from flask import logging
from shared.services.database_service import db
from ..models.user import User, CarModel, CabRide, cabModel, Shift

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