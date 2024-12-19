import logging
from ..models.driver import Driver
from ..services.driver_service import DriverService
from flask import request, jsonify , abort

driver_service = DriverService()
class DriverController:
    @staticmethod
    def get_driver_info():
        phone = request.args.get('phone')
        print(phone)
        if not phone:
            abort(400, description="Bad request: No phone number provided.")
        
        driver = driver_service.get_driver_by_phone(phone)
        if driver:
            return jsonify({
                'Driver_ID': driver["Driver_ID"],
                'firstname': driver["Firstname"],
                'lastname': driver["Lastname"],
                'SDT': driver["SDT"],
                'Wallet': driver["Wallet"],
                'DOB': driver["DOB"],
                'gender': driver['Gender'],
                'Address': driver['Address'],
                'CCCD': driver['CCCD'],
                'Driving_license': driver['Driving_licence_number'],
                'Working_experiment': driver['Working_experiment']
            }), 200
        else:
            abort(404, description="User not found.")
    @staticmethod
    def update_info():
        driver_data = request.json
        if not driver_data:
            abort(400, description = "No data provided.")
        driver = Driver.from_dict(driver_data)
        updated_rows = driver_service.update_driver_info(driver)
        if updated_rows:
            return jsonify({"message": "Driver info updated successfully!"}), 200
        else:
            return jsonify({"message": "Failed to update driver info."}), 404
    @staticmethod
    def shift_info():
        driver_id = request.args.get('driver_id')
        print(driver_id)
        if not driver_id:
            abort(400, "Bad request: No driver_id provided")
        shift = driver_service.get_shift(driver_id)
        if shift is None:
            abort(404, "No shift infomation found for this driver_id")
        return jsonify([s.__dict__ for s in shift])
    @staticmethod
    def cab():
        cabs = driver_service.get_cab()
        if cabs is None:
            abort(404, "No cab")
        return jsonify([c.__dict__ for c in cabs]) 
    @staticmethod
    def cab_ride():
        driver_id = request.args.get('driver_id')
        if not driver_id:
            abort(400, "Bad request: No driver_id provided")
        cab_ride = driver_service.get_cab_ride(driver_id)
        if not cab_ride:
            abort(404, "No cab ride found for this driver_id")
        return jsonify([ride.to_dict() for ride in cab_ride])
    @staticmethod
    def postLocation():
        location = request.json
        if not location:
            abort(404, "Can't get location")
        driver_id = location.get('driver_id')
        longitude = location.get('longitude')
        latitude = location.get('latitude')
        current_address = location.get('current_address', None)
        if not driver_id or longitude is None or latitude is None:
            abort(400, "Missing attribute")
        update_rows = driver_service.post_location(driver_id, longitude, latitude, current_address)
        if update_rows:        
            return jsonify({"message": "Get location successfully!"}), 200
        else:
            return jsonify({"message": "Get location unsuccessfully!"}), 404
    def clearPostion():
        driver_id = request.args.get('driver_id')
        if not driver_id:
            abort(400, "Missing driver_id")
        update_rows = driver_service.clear_position(driver_id)
        if update_rows > 0:
            return jsonify({"message": "Clear successfully"}), 200
        else:
            return jsonify({"message": "Clear failed"}), 404
    def get_pending_bookings():
        driver_id = request.args.get('driver_id')
        if not driver_id:
            abort(404, description = "Missing attribute")
        bookings = driver_service.list_request(driver_id)
        if bookings:
            return jsonify(
                [booking.to_dict() for booking in bookings]
            ), 200
        else:
            return jsonify({
                "message": "No pending bookings found for this driver"
            }), 404
    def accept_booking():
        try:
            booking_id = request.json.get('booking_id')
            driver_id = request.json.get('driver_id')
            logging.info(f"Received booking_id: {booking_id}, driver_id: {driver_id}")
            if not booking_id or not driver_id:
                return jsonify({"message": "Missing attributes"}), 400
            result = driver_service.accept_booking(booking_id, driver_id)

            if result:
                return jsonify({
                    "message": "Booking accepted"
                }), 200
            else:
                return jsonify({
                    "message": "Booking failed"
                }), 400
        except Exception as e:
            return jsonify({"message": f"Error: {str(e)}"}), 500


