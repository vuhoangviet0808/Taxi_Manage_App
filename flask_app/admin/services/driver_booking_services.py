from shared.services.database_service import db
from ..models.driver_booking import DriverBooking

class DriverBookingService:
    def get_earliest_assigned_bookings(self):
        query = """
            SELECT bd.booking_id, bd.driver_id, bd.status, bd.status_changed_at
            FROM booking_driver bd
            JOIN (
                SELECT booking_id, MIN(status_changed_at) AS earliest_status_changed_at
                FROM booking_driver
                WHERE status = 'assigned'
                GROUP BY booking_id
            ) earliest_bd
            ON bd.booking_id = earliest_bd.booking_id
            AND bd.status_changed_at = earliest_bd.earliest_status_changed_at
            WHERE bd.status = 'assigned'
            ORDER BY bd.status_changed_at ASC;
        """
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query)
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


    def count_earliest_assigned_bookings(self):
        query = """
            SELECT COUNT(*) AS count
            FROM booking_driver bd
            JOIN (
                SELECT booking_id, MIN(status_changed_at) AS earliest_status_changed_at
                FROM booking_driver
                WHERE status = 'assigned'
                GROUP BY booking_id
            ) earliest_bd
            ON bd.booking_id = earliest_bd.booking_id
            AND bd.status_changed_at = earliest_bd.earliest_status_changed_at
            WHERE bd.status = 'assigned';
        """
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query)
            result = cursor.fetchone()
            if result:
                return result['count']  # Trả về số lượng booking
            else:
                print("No results found.")
                return 0
        except Exception as e:
            print("Error occurred:", e)
            return 0
        finally:
            cursor.close()


    def insert_driver_id_into_booking_request(self, booking_id, driver_id):
            query = """
                UPDATE booking_requests
                SET driver_id = %s, status = 'assigned'
                WHERE booking_id = %s
            """
            cursor = db.cursor()
            try:
                cursor.execute(query, (driver_id, booking_id))
                db.commit()  # Commit the changes to the database
                if cursor.rowcount > 0:
                    print(f"Successfully updated booking_id {booking_id} with driver_id {driver_id}.")
                    return True
                else:
                    print(f"No booking request found with booking_id {booking_id}.")
                    return False
            except Exception as e:
                print("Error occurred:", e)
                db.rollback()  # Rollback in case of error
                return False
            finally:
                cursor.close()

                
    def delete_booking_by_id(self, booking_id):
        query = """
            DELETE FROM booking_driver
            WHERE booking_id = %s
        """
        cursor = db.cursor()
        try:
            cursor.execute(query, (booking_id,))
            db.commit()  # Commit thay đổi vào cơ sở dữ liệu
            if cursor.rowcount > 0:
                print(f"Successfully deleted booking_id {booking_id}.")
                return True
            else:
                print(f"No booking found with booking_id {booking_id}.")
                return False
        except Exception as e:
            print("Error occurred:", e)
            db.rollback()  # Rollback nếu có lỗi
            return False
        finally:
            cursor.close()