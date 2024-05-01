from flask import jsonify
from models.driver import Driver
from flask import Blueprint

driver_blueprint = Blueprint('driver', __name__)

@driver_blueprint.route('/drivers')
def get_drivers():
    drivers = [
        {"họ tên": "Monica Geller", "ngày sinh": "01/01/1990"},
        {"họ tên": "Chandler Bing", "ngày sinh": "02/02/1991"},
        {"họ tên": "Rachel Green", "ngày sinh": "03/03/1992"},
        {"họ tên": "Ross Geller", "ngày sinh": "04/04/1993"},
        {"họ tên": "Joey Buffay", "ngày sinh": "05/05/1994"}
    ]
    return jsonify(drivers)