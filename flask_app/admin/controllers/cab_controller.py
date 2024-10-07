from flask import jsonify, abort
from ..services.cab_services import CabService

cab_service = CabService()

class CabController:
    def get_2_cab_info(self):
        cabs = cab_service.get_cab_by_ID_and_licence_plate()
        if cabs:
            cab_info = []
            for cab in cabs:
                cab_info.append({
                    'ID': cab["ID"],
                    'licence_plate': cab["licence_plate"],
                })
            return jsonify(cab_info), 200
        else:
            abort(404, description="No cabs found.")

    def get_full_cab_info(self, ID):
        cabs = cab_service.get_cab_by_all(ID)
        if cabs:
            cab_info = []
            for cab in cabs:
                cab_info.append({
                    'ID': cab["ID"],
                    'licence_plate': cab["licence_plate"],
                    'car_type': cab["car_type"],
                    'manufacture_year' : cab["manufacture_year"],
                    'active': cab["active"],
                })
            return jsonify(cab_info), 200
        else:
            abort(404, description="No cabs found.")