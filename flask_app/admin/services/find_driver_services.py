
from shared.services.database_service import db
from admin.services.calculate_boundingbox import calculate_bounding_box


class FindDriverService:
    @staticmethod
    def find_driver_for_booking_request(booking_id):
        # Truy vấn để lấy tọa độ từ bảng booking_requests
        query = "SELECT ST_X(gps_pick_up_location), ST_Y(gps_pick_up_location) FROM booking_requests WHERE booking_id = %s"
        try:
            cursor = db.cursor()
            cursor.execute(query, (booking_id,))
            result = cursor.fetchone()
            cursor.close()

            if result:
                lon = result[0]
                lat = result[1]

                # Tính toán bounding box dựa trên tọa độ pick-up và bán kính 3 km
                min_lat, max_lat, min_lon, max_lon = calculate_bounding_box(lat, lon)

                # Truy vấn tìm tài xế trong bounding box
                query = """
                    SELECT ID, Driver_id
                    FROM Shift
                    WHERE ST_Y(current_gps_location) BETWEEN %s AND %s
                      AND ST_X(current_gps_location) BETWEEN %s AND %s
                      
                """
                params = (min_lat, max_lat, min_lon, max_lon)

                cursor = db.cursor()
                cursor.execute(query, params)
                results = cursor.fetchall()
                cursor.close()

                return results
            else:
                print(f"No booking request found with ID: {booking_id}")
                return []
        except Exception as e:
            print(f"Error finding drivers: {e}")
            return []