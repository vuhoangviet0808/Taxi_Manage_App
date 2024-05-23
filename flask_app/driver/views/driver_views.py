from flask import Blueprint, jsonify
from flask_cors import CORS
from ..controller.driver_controller import  DriverController

driver_blueprint = Blueprint('driver', __name__)

@driver_blueprint.route('/')
def driver_index():
    return jsonify({"message": "Welcome to User Dashboard"})

@driver_blueprint.route('/getinfo', methods=['GET'])
def driver_getinfo():
    return DriverController.get_driver_info()

@driver_blueprint.route('/update_driver_infor', methods = ['POST'])
def driver_updateinfo():    
    return DriverController.update_info()

@driver_blueprint.route('/getShift', methods = ['GET'])
def shift_get_info():
    return DriverController.shift_info()

@driver_blueprint.route('/getCarModel', methods = ['GET'])
def get_car_model():
    return DriverController.car_model()

@driver_blueprint.route('/getCab', methods = ['GET'])
def get_cab():
    return DriverController.cab()
