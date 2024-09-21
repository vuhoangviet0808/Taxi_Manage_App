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

    def get_full_cab_ride_info(self, ID):
        cab_rides = cab_ride_services.get_cab_ride_by_all(ID)
        if cab_rides:
            cab_rides_info = []
            for cab_ride in cab_rides:
                cab_rides_info.append({
                    'ID': cab_ride["ID"],
                    'shift_ID': cab_ride["shift_id"],
                    'user_ID' : cab_ride["user_id"],
                    'ride_start_time': cab_ride["ride_start_time"],
                    "ride_end_time": cab_ride["ride_end_time"],
                    "address_starting_point": cab_ride["address_starting_point"],
                    "GPS_starting_point": cab_ride["GPS_starting_point"],
                    "address_destination": cab_ride["address_destination"],
                    "GPS_destination": cab_ride["GPS_destination"],
                    "canceled": cab_ride["canceled"],
                    "payment_type_id": cab_ride["payment_type_id"],
                    "price": cab_ride["price"],
                    "response": cab_ride["response"],
                    "evaluate": cab_ride["evaluate"],
                    
                })
            return jsonify(cab_rides_info), 200
        else:
            abort(404, description="No cab_ride found.")