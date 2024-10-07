from flask import jsonify, abort
from ..services.insert_driver_services import InsertBookingDriverService
from ..services.find_driver_services import FindDriverService

class InsertBookingDriverController:
    def __init__(self):
        self.insert_booking_driver_service = InsertBookingDriverService()

    def insert_drivers(self, booking_id):
        try:
            # Gọi service để tìm tài xế trong bounding box
            find_driver_service = FindDriverService()
            drivers = find_driver_service.find_driver_for_booking_request(booking_id)
            driver_ids = [driver[1] for driver in drivers]
            for driver_id in driver_ids:
                print(f"Inserting booking_id: {booking_id}, driver_id: {driver_id}")

            if not driver_ids:
                abort(404, description="No drivers found in the bounding box.")

            # Gọi service để chèn các cặp driver_id và booking_id vào bảng booking_driver
            self.insert_booking_driver_service.insert_drivers_for_booking(booking_id, driver_ids)
            return jsonify({'message': 'Drivers successfully inserted for booking.'}), 201
        except Exception as e:
            abort(500, description=f"Internal Server Error: {str(e)}")