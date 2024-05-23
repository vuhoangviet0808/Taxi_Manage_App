from flask import Blueprint 
from flask_cors import CORS
from ..controllers.auth_controller import login
from ..controllers.register_controller import RegisterController

auth_blueprint = Blueprint('auth', __name__)
CORS(auth_blueprint)

@auth_blueprint.route('/login', methods=['POST'])
def login_route():
    return login()
@auth_blueprint.route('/register', methods=['POST'])
def register_route():
    return RegisterController.register()

@auth_blueprint.route('/infoinput', methods=['POST'])
def infoinput_route():
    return RegisterController.register_input_info()