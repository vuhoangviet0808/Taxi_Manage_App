from flask import Blueprint
from flask_cors import CORS
from ..controllers.auth_controller import login

auth_blueprint = Blueprint('auth', __name__)
CORS(auth_blueprint)

@auth_blueprint.route('/login', methods=['POST'])
def login_route():
    return login()
