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
    def car_model():
        car_id = request.args.get('car_model_id')
        if not car_id:
            abort(400, "Bad request: No car_model_id provided")
        car_model =  driver_service.get_car_model(car_id)
        if car_model is None:
            abort(404, "No Information")
        return jsonify(car_model.__dict__)
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
        return jsonify([ride.__dict__ for ride in cab_ride])