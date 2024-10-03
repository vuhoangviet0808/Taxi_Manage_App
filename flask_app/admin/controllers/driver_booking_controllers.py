from flask import jsonify, abort
from ..services.driver_booking_services import DriverBookingService

driver_booking_service = DriverBookingService()

class DriverBookingController:
    def get_earliest_assigned_driver_bookings(self):
        bookings = driver_booking_service.get_earliest_assigned_bookings()
        if bookings:
            booking_info = []
            for booking in bookings:
                booking_info.append({
                    'booking_id': booking["booking_id"],
                    'driver_id': booking["driver_id"],
                    'status': booking["status"],
                    'status_changed_at': booking["status_changed_at"]
                })
            return jsonify(booking_info), 200
        else:
            abort(404, description="No assigned bookings found.")

            
    def insert_driver_id(self, booking_id, driver_id):
        success = driver_booking_service.insert_driver_id_into_booking_request(booking_id, driver_id)
        if success:
            return jsonify({"message": "Driver ID successfully updated."}), 200
        else:
            abort(404, description="Booking ID not found or update failed.")
    
    def delete_booking_by_id(self, booking_id):
        success = driver_booking_service.delete_booking_by_id(booking_id)
        if success:
            return jsonify({"message": f"Booking ID {booking_id} successfully deleted."}), 200
        else:
            abort(404, description=f"Booking ID {booking_id} not found or deletion failed.")