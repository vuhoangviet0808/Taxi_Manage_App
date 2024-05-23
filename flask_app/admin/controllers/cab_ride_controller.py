from flask import jsonify, abort
from ..services.cab_ride_services import Cab_rideService

cab_ride_services = Cab_rideService()

class Cab_rideController:
    def get_2_cab_ride_info(self):
        cab_rides = cab_ride_services.get_cab_ride_by_ID_and_startTime()
        if cab_rides:
            cab_rides_info = []
            for cab_ride in cab_rides:
                cab_rides_info.append({
                    'ID': cab_ride["ID"],
                    'ride_start_time': cab_ride["ride_start_time"]
                })
            return jsonify(cab_rides_info), 200
        else:
            abort(404, description="No cab_ride found.")