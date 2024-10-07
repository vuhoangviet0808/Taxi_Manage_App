
from flask import jsonify, abort
from ..services.find_driver_services import FindDriverService

class FindDriverController:
    def __init__(self):
        self.find_driver_service = FindDriverService()

    def get_drivers_in_bounding_box(self, booking_id):
        try:
            # Gọi service để tìm tài xế trong bounding box
            drivers = self.find_driver_service.find_driver_for_booking_request(booking_id)
            if drivers:
                driver_info = []
                for driver in drivers:
                    driver_info.append({
                        'Shift_ID': driver[0],
                        'Driver_ID': driver[1]
                    })
                return jsonify(driver_info), 200
            else:
                abort(404, description="No drivers found in the bounding box.")
        except Exception as e:
            abort(500, description=f"Internal Server Error: {str(e)}")