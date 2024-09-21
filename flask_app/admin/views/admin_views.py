from flask import Blueprint, jsonify, request
from datetime import datetime
from ..controllers.admin_controller import AdminController
from ..controllers.cab_ride_controller import Cab_rideController
from ..controllers.user_controller import UserController
from ..controllers.shift_controller import ShiftController
from ..controllers.cab_controller import CabController
from ..controllers.driver_revenue_controller import calculate_driver_revenue
from ..controllers.company_revenue_controller import calculate_company_revenue
from ..controllers.get_driver_by_revenue_controller import get_drivers_by_revenue_controller


admin_blueprint = Blueprint('admin', __name__)

@admin_blueprint.route('/')
def driver_index():
    return jsonify({"message": "Welcome to Admin Dashboard"})

@admin_blueprint.route('/drivers', methods=['GET'])
def driver_get_info():
    return AdminController().get_all_driver_info()

@admin_blueprint.route('/drivers/<int:driver_id>', methods=['GET'])
def each_driver_by_id_info(driver_id):
    return AdminController().get_full_driver_info(driver_id)

@admin_blueprint.route('/cab_rides', methods=['GET'])
def cab_ride_get_2_info():
    return Cab_rideController().get_2_cab_ride_info()

@admin_blueprint.route('/cab_rides/<int:cab_ride_id>', methods=['GET'])
def each_cab_ride_by_id_info(cab_ride_id):
    return Cab_rideController().get_full_cab_ride_info(cab_ride_id)

@admin_blueprint.route('/users', methods=['GET'])
def user_get_2_info():
    return UserController().get_2_user_info()

@admin_blueprint.route('/users/<int:user_id>', methods=['GET'])
def each_user_by_id_info(user_id):
    return UserController().get_full_user_info(user_id)

@admin_blueprint.route('/shifts', methods=['GET'])
def shift_get_2_info():
    return ShiftController().get_2_shift_info()

@admin_blueprint.route('/shifts/<int:id>', methods=['GET'])
def each_shift_by_id_info(id):
    return ShiftController().get_full_shift_info(id)

@admin_blueprint.route('/cabs', methods=['GET'])
def cab_get_2_info():
    return CabController().get_2_cab_info()

@admin_blueprint.route('/cabs/<int:id>', methods=['GET'])
def each_cab_by_id_info(id):
    return CabController().get_full_cab_info(id)


@admin_blueprint.route('/driver_revenue', methods=['GET'])
def driver_get_revenue():
    driver_id = request.args.get('driver_id', type=int)
    start_date_str = request.args.get('start_date')
    end_date_str = request.args.get('end_date')

    if not driver_id or not start_date_str or not end_date_str:
        return jsonify({"error": "Missing required parameters."}), 400

    try:
        # Gọi hàm calculate_driver_revenue với chuỗi ngày tháng
        response, status_code = calculate_driver_revenue(driver_id, start_date_str, end_date_str)

        return jsonify(response), status_code

    except ValueError:
        return jsonify({"error": "Incorrect date format, should be dd-mm-yyyy."}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@admin_blueprint.route('/company_revenue', methods=['GET'])
def company_get_revenue():
    start_date_str = request.args.get('start_date')
    end_date_str = request.args.get('end_date')

    if not start_date_str or not end_date_str:
        return jsonify({"error": "Missing required parameters."}), 400

    try:
        # Gọi hàm calculate_company_revenue với chuỗi ngày tháng
        response, status_code = calculate_company_revenue(start_date_str, end_date_str)

        # Đảm bảo response là dict trước khi trả về
        return jsonify(response), status_code

    except ValueError:
        return jsonify({"error": "Incorrect date format, should be dd-mm-yyyy."}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@admin_blueprint.route('/driver_by_revenue', methods=['GET'])
def driver_by_revenue():
    start_date_str = request.args.get('start_date')
    end_date_str = request.args.get('end_date')

    if not start_date_str or not end_date_str:
        return jsonify({"error": "Missing required parameters."}), 400

    try:
        # Gọi hàm get_drivers_by_revenue_controller với chuỗi ngày tháng
        response, status_code = get_drivers_by_revenue_controller(start_date_str, end_date_str)

        # Đảm bảo response là dict trước khi trả về
        return jsonify(response), status_code

    except ValueError:
        return jsonify({"error": "Incorrect date format, should be dd-mm-yyyy."}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500