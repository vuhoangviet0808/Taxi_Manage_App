from ..services.admin_services import AdminService
from flask import jsonify, abort

admin_service = AdminService()

class AdminController:
    def get_all_driver_info(self):
        drivers = admin_service.get_driver_by_name_and_cccd()
        if drivers:
            driver_info = []
            for driver in drivers:
                driver_info.append({
                    'Firstname': driver["Firstname"],
                    'Lastname' : driver["Lastname"],
                    'Driver_ID': driver["Driver_ID"]
                })
            return jsonify(driver_info), 200
        else:
            abort(404, description="No drivers found.")

    
    def get_full_driver_info(self, Driver_ID):
       
        drivers = admin_service.get_driver_by_all(Driver_ID)
        if drivers:
            driver_info = []
            for driver in drivers:
                driver_info.append({
                    'Driver_ID': driver["Driver_ID"],
                    'SDT': driver["SDT"],
                    'Firstname': driver["Firstname"],
                    'Lastname' : driver["Lastname"],
                    'Wallet'   : driver["Wallet"],
                    'DOB'      : driver["DOB"],
                    'Gender'   : driver["Gender"],
                    'Address'  : driver["Address"],
                    'CCCD'     : driver["CCCD"],
                    'Driving_licence_number' : driver["Driving_licence_number"],
                    'Working_experiment'     : driver["Working_experiment"],
                })
            return jsonify(driver_info), 200
        else:
            abort(404, description="No drivers found.")