from flask_app.driver.models.driver import Driver
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