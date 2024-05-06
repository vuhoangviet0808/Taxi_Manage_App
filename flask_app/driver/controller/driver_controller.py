from ..services.driver_service import DriverService
from flask import request, jsonify , abort



driver_service = DriverService()
class DriverController:
    def get_driver_info():
        phone = request.args.get('phone')
        print(phone)
        if not phone:
            abort(400, description="Bad request: No phone number provided.")
        
        driver = driver_service.get_user_by_phone(phone)
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
                'Driving_license': driver['Driving_license_number'],
                'Working_experiment': driver['Working_experiment']
            }), 200
        else:
            abort(404, description="User not found.")