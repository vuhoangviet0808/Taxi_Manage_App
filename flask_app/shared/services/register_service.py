from .database_service import db


class RegisterService:
    def check_phone(self, phone):
        query = "SELECT * FROM account WHERE SDT = %s"
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (phone,))
            result = cursor.fetchone() 
            if result is not None:
                return False  # Phone number already exists
            return True
        except Exception as e:
            print("Error occurred:", e)
            return False
        finally:
            cursor.close()
    
    def register_new_user(self, phone, password):
        query = "Insert into account values(%s, %s, %s, %s)"
        cursor = db.cursor()
        try:
            cursor.execute(query, (phone, password,'user','active'))
            db.commit()
            if cursor.rowcount > 0:
                print("User registered successfully.")
                return True
            else:
                print("Registration failed.")
                return False
        except Exception as e:
            db.rollback() 
            print(f"An error occurred: {e}")
            return False
        finally:
            cursor.close()

