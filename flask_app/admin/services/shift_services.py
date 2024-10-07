
from shared.services.database_service import db
from ..models.shift import Shift

class ShiftService:
    def get_shift_by_ID_and_current_gps_location(self):
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute("""
                SELECT ID, Driver_id, cab_id, current_gps_location, current_address, evaluate
                FROM Shift
                ORDER BY ID DESC
            """)
            result = cursor.fetchall()
            if result:
                return [
                    Shift(
                        shift["ID"],
                        shift["Driver_id"],
                        shift["cab_id"],
                        self._convert_point(shift.get("current_gps_location")),
                        shift.get("current_address"),
                        shift.get("evaluate")
                    ) for shift in result
                ]
            else:
                print("No result found.")
                return None
        except Exception as e:
            print("Error occurred: ", e)
            return None
        finally:
            cursor.close()

    def _convert_point(self, point):
        """Convert POINT data to a tuple (longitude, latitude) or return None."""
        if point:
            # Assuming point is a bytes-like object, you can decode it or use appropriate methods.
            # Here I'm just returning a placeholder; you may need to adjust it based on your actual POINT data handling.
            return (point.x, point.y)  # Example if point is a custom object
        return None

    def get_shift_by_all(self, ID):
        query = "SELECT * FROM Shift WHERE ID = %s"
        cursor = db.cursor(dictionary=True)
        try:
            cursor.execute(query, (ID,))
            result = cursor.fetchone()
            if result:
                return Shift(
                    result["ID"],
                    result["Driver_id"],
                    result["cab_id"],
                    self._convert_point(result.get("current_gps_location")),
                    result.get("current_address"),
                    result.get("evaluate")
                )
            else:
                print("No results found")
                return None
        except Exception as e:
            print("Error occurred:", e)
            return None
        finally:
            cursor.close()