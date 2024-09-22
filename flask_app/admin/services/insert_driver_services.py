from shared.services.database_service import db

class InsertBookingDriverService:
    @staticmethod
    def insert_drivers_for_booking(booking_id, driver_ids):
        # Tạo câu truy vấn để chèn các cặp driver_id và booking_id vào bảng booking_driver
        query = "INSERT INTO booking_driver (booking_id, driver_id, status) VALUES (%s, %s, 'pending')"
        try:
            cursor = db.cursor()
            # Chèn từng cặp driver_id và booking_id vào bảng booking_driver
            for driver_id in driver_ids:
                cursor.execute(query, (booking_id, driver_id))
            db.commit()  # Commit để lưu thay đổi
            print(f"Successfully committed changes to the database")
            cursor.close()
            print(f"Successfully inserted drivers for booking ID: {booking_id}")
        except Exception as e:
            db.rollback()  # Rollback nếu có lỗi
            print(f"Error inserting drivers for booking: {e}")
            raise