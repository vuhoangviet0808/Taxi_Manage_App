from flask import Blueprint, jsonify
from ..controllers.admin_controller import AdminController
from ..controllers.cab_ride_controller import Cab_rideController
admin_blueprint = Blueprint('admin', __name__)

@admin_blueprint.route('/')
def driver_index():
    return jsonify({"message": "Welcome to Admin Dashboard"})

@admin_blueprint.route('/drivers', methods=['GET'])
def driver_get_info():
    return AdminController().get_all_driver_info()

@admin_blueprint.route('/drivers/<int:Driver_ID>', methods=['GET'])
def each_driver_by_id_info(Driver_ID):
    return AdminController().get_full_driver_info(Driver_ID)

@admin_blueprint.route('/cab_rides', methods=['GET'])
def cab_ride_get_2_info():
    return Cab_rideController().get_2_cab_ride_info()