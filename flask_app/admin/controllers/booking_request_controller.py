from flask import jsonify, abort
from ..services.booking_request_services import BookingRequestService

booking_request_service = BookingRequestService()

class BookingRequestController:
    def get_basic_booking_request_info(self):
        bookings = booking_request_service.get_booking_request_basic()
        if bookings:
            booking_info = []
            for booking in bookings:
                booking_info.append({
                    'booking_id': booking["booking_id"],
                    'pickup_location': booking["pickup_location"],
                    'status': booking["status"]
                })
            return jsonify(booking_info), 200
        else:
            abort(404, description="No booking requests found.")

    def get_full_booking_request_info(self, booking_id):
        bookings = booking_request_service.get_booking_request_full(booking_id)
        if bookings:
            booking_info = []
            for booking in bookings:
                
                pickup_latitude = booking.get("pickup_latitude")
                pickup_longitude = booking.get("pickup_longitude")
                destination_latitude = booking.get("destination_latitude")
                destination_longitude = booking.get("destination_longitude")

                booking_info.append({
                    'booking_id': booking["booking_id"],
                    'user_id': booking["user_id"],
                    'requested_car_type': booking["requested_car_type"],
                    'pickup_location': booking["pickup_location"],
                    'dropoff_location': booking["dropoff_location"],
                    'pickup_longitude': pickup_longitude,  
                    'pickup_latitude': pickup_latitude,  
                    'destination_longitude': destination_longitude,  
                    'destination_latitude': destination_latitude,  
                    'price': booking["price"],
                    'request_time': booking["request_time"],
                    'status': booking["status"],
                    'driver_id': booking["driver_id"]
                })
            return jsonify(booking_info), 200
        else:
            abort(404, description="No booking request found for the given ID.")