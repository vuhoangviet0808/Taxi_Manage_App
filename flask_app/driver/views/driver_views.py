from flask import Blueprint, jsonify
from flask_cors import CORS

driver_blueprint = Blueprint('driver', __name__)

@driver_blueprint.route('/')
def driver_index():
    return jsonify({"message": "Welcome to User Dashboard"})

