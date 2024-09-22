
from flask import jsonify, abort
from ..services.cab_ride_services import CabRideService

cab_ride_services = CabRideService()

class Cab_rideController:
    def get_2_cab_ride_info(self):
        cab_rides = cab_ride_services.get_cab_ride_by_ID_and_startTime()
        if cab_rides:
            cab_rides_info = []
            for cab_ride in cab_rides:
                cab_rides_info.append({
                    'ID': cab_ride.get("ID"),  # Safely access dictionary
                    'ride_start_time': cab_ride.get("ride_start_time")
                })
            return jsonify(cab_rides_info), 200
        else:
            abort(404, description="No cab ride found.")

    def get_full_cab_ride_info(self, ID):
        cab_ride = cab_ride_services.get_cab_ride_by_all(ID)
        if cab_ride:
            cab_ride_info = {
                'ID': cab_ride.get("ID"),  # Safely access dictionary
                'shift_ID': cab_ride.get("shift_id"),
                'user_ID': cab_ride.get("user_id"),
                'ride_start_time': cab_ride.get("ride_start_time"),
                'ride_end_time': cab_ride.get("ride_end_time"),
                'address_starting_point': cab_ride.get("address_starting_point"),
                'GPS_starting_point': (cab_ride.get("lat_start"), cab_ride.get("lon_start")),
                'address_destination': cab_ride.get("address_destination"),
                'GPS_destination': (cab_ride.get("lat_dest"), cab_ride.get("lon_dest")),
                'cancelled_by': cab_ride.get("cancelled_by"),
                'price': cab_ride.get("price"),
                'response': cab_ride.get("response"),
                'evaluate': cab_ride.get("evaluate"),
            }
            return jsonify(cab_ride_info), 200
        else:
            abort(404, description="No cab ride found.")