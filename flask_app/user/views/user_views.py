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