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
@driver_blueprint.route('/update_driver_info', methods = ['POST'])
def driver_updateinfo():
    return DriverController.update_info()