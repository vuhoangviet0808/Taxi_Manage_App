from flask import jsonify
from models.order import Order
from flask import Blueprint

order_blueprint = Blueprint('order', __name__)

@order_blueprint.route('/orders')
def get_orders():
    orders = [
        {"thời gian": "01:02:33", "ngày": "28/4/2024"},
        {"thời gian": "02:02:33", "ngày": "29/4/2024"},
        {"thời gian": "03:02:33", "ngày": "30/4/2024"},
        {"thời gian": "04:02:33", "ngày": "1/5/2024"},
        {"thời gian": "05:02:33", "ngày": "2/5/2024"},
    ]
    return jsonify(orders)