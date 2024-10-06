from flask import Blueprint, jsonify
from flask_cors import CORS
from ..controllers.user_controller import UserController 

user_blueprint = Blueprint('user', __name__)

@user_blueprint.route('/')
def user_index():
    return jsonify({"message": "Welcome to User Dashboard"})
@user_blueprint.route('/getinfo', methods=['Get'])
def user_get_info():
    return UserController.get_user_info()
@user_blueprint.route('/update_user_infor', methods = ['POST'])
def user_updateinfo():    
    return UserController.update_info()
@user_blueprint.route('/getCarModel', methods = ['GET'])
def get_car_model():
    return UserController.car_model()
@user_blueprint.route('/getCabRide', methods = ['GET'])
def get_cab_ride():
    return UserController.cab_ride()
@user_blueprint.route('/sendBookingRequest', methods=['POST'])
def send_booking_request():
    return UserController.send_booking_request()
@user_blueprint.route('/getLatestBookingId', methods=['GET'])
def get_latest_booking_id():
    return UserController.get_latest_booking_id()
@user_blueprint.route('/getDriverIdByLatestBooking', methods=['GET'])
def get_driver_id_by_latest_booking():
    return UserController.get_driver_id_by_latest_booking()
@user_blueprint.route('/getCabRideByDriverId', methods=['GET'])
def get_cab_ride_by_driver_id():
    return UserController.get_cab_ride_by_driver_id()
@user_blueprint.route('/updateCabRideEvaluate', methods=['POST'])
def update_cab_ride_evaluate():
    return UserController.update_cab_ride_evaluate()
@user_blueprint.route('/getCabByDriverId', methods=['GET'])
def get_cab_by_driver_id():
    return UserController.get_cab_by_driver_id()
@user_blueprint.route('/getDriverById', methods=['GET'])
def get_driver_by_id():
    return UserController.get_driver_by_id()
@user_blueprint.route('/getEvaluateByDriverId', methods=['GET'])
def get_evaluate_by_driver_id():
    return UserController.get_evaluate_by_driver_id()
@user_blueprint.route('/cancelLatestBooking', methods=['POST'])
def cancel_latest_booking():
    return UserController.cancel_latest_booking()