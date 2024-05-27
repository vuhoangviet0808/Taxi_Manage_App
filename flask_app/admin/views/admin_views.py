from flask import Blueprint, jsonify
from ..controllers.admin_controller import AdminController
from ..controllers.cab_ride_controller import Cab_rideController
from ..controllers.user_controller import UserController
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

@admin_blueprint.route('/cab_rides/<int:Cab_Ride_ID>', methods=['GET'])
def each_cab_ride_by_id_info(Cab_Ride_ID):
    return Cab_rideController().get_full_cab_ride_info(Cab_Ride_ID)

@admin_blueprint.route('/users', methods = ['GET'])
def user_get_2_info():
    return UserController().get_2_user_info()

@admin_blueprint.route('/users/<int:User_ID>', methods=['GET'])
def each_user_by_id_info(User_ID):
    return UserController().get_full_user_info(User_ID)