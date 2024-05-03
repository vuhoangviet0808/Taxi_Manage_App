from flask import Flask, Blueprint,jsonify
from ..controllers.controller import get_drivers, get_orders

admin_blueprint = Blueprint('admin', __name__)

@admin_blueprint.route('/')
def admin_index():
    return jsonify({"message": "Welcome to Admin Dashboard"})

@admin_blueprint.route('/orders')
def order_route():
    return get_orders()

@admin_blueprint.route('/drivers')
def driver_route():
    return get_drivers()