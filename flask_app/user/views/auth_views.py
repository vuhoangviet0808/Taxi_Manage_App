from flask import Blueprint
from ..controllers.auth_controller import login

auth_blueprint = Blueprint('auth', __name__)

auth_blueprint.route('/login', methods=['POST'])(login)
