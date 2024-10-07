from ..models.user import User, Driver, CabRide,Cab, Shift
from ..services.user_service import UserService
from flask import request, jsonify, abort, current_app
import threading
import time
from datetime import datetime


# Khởi tạo đối tượng user_service
user_service = UserService()

class UserController:
    # Hàm lấy thông tin người dùng dựa trên số điện thoại
    @staticmethod
    def get_user_info():
        phone = request.args.get('phone')
        if not phone:
            abort(400, description="Bad request: No phone number provided.")
    
        user = user_service.get_user_by_phone(phone)
        if user:
            return jsonify({
                'User_ID': user['User_ID'],
                'firstname': user["Firstname"],
                'lastname': user["Lastname"],
                'SDT': user["SDT"],
                'Wallet': user["Wallet"],
                'DOB': user["DOB"],
                'gender': user['Gender'],
                'Address': user['Address'],
                'CCCD': user['CCCD'],
                'user_token': user['user_token']  # Thêm user_token nếu cần
            }), 200
        else:
            abort(404, description="User not found.")

    # Hàm cập nhật thông tin người dùng
    @staticmethod
    def update_info():
        user_data = request.json
        if not user_data:
            abort(400, description="No data provided.")
    
        user = User.from_dict(user_data)
        print("Updating user:", user.firstname, user.lastname, user.address, user.gender, user.cccd, user.dob)
    
        updated_rows = user_service.update_user_info(user)
        if updated_rows:
            return jsonify({"message": "User info updated successfully!"}), 200
        else:
            return jsonify({"message": "Failed to update user info."}), 404

    # Hàm lấy thông tin loại xe dựa trên car_model_id
    @staticmethod
    def car_model():
        car_id = request.args.get('car_model_id')
        if not car_id:
            abort(400, "Bad request: No car_model_id provided")
    
        car_model = user_service.get_car_model(car_id)
        if car_model is None:
            abort(404, "No Information")
    
        return jsonify({"car_type": car_model})  # Trả về car_type


    # Hàm lấy các chuyến đi dựa trên user_id
    @staticmethod
    def cab_ride():
        user_id = request.args.get('user_id')
        if not user_id:
            abort(400, "Bad request: No user_id provided")
        cab_ride = user_service.get_cab_ride(user_id)
        if not cab_ride:
            abort(404, "No cab ride found for this user_id")
        return jsonify([ride.__dict__ for ride in cab_ride])

    # Hàm gửi yêu cầu đặt xe
    @staticmethod
    def send_booking_request():
        # Nhận dữ liệu từ yêu cầu POST
        booking_data = request.json
        if not booking_data:
            abort(400, description="No booking data provided.")
        
        # Gọi phương thức send_booking_request trong UserService
        booking_id = user_service.send_booking_request(booking_data)
        
        if booking_id:
            return jsonify({"message": "Booking request sent successfully!", "booking_id": booking_id}), 201
        else:
            return jsonify({"message": "Failed to send booking request."}), 500


    
     # Hàm lấy booking_id mới nhất dựa trên user_id
    @staticmethod
    def get_latest_booking_id():
        # Lấy user_id từ tham số truyền vào URL
        user_id = request.args.get('user_id')
        if not user_id:
            abort(400, description="Bad request: No user_id provided.")
        
        # Gọi phương thức get_latest_booking_id từ UserService
        latest_booking_id = user_service.get_latest_booking_id(user_id)
        
        if latest_booking_id:
            return jsonify({"latest_booking_id": latest_booking_id}), 200
        else:
            return jsonify({"message": "No booking found for the given user_id"}), 404
        

    # Hàm lấy driver_id dựa trên booking_id mới nhất
    @staticmethod
    def get_driver_id_by_latest_booking():
        # Lấy booking_id từ tham số truyền vào URL
        booking_id = request.args.get('booking_id')
        if not booking_id:
            abort(400, description="Bad request: No booking_id provided.")
        
        # Gọi phương thức get_driver_id_by_latest_booking từ UserService
        driver_id = user_service.get_driver_id_by_latest_booking(booking_id)
        
        if driver_id:
            return jsonify({"driver_id": driver_id}), 200
        else:
            return jsonify({"message": "No driver found for the given booking_id"}), 404# Hàm lấy thông tin cab_ride mới nhất dựa trên driver_id
    @staticmethod
    def get_cab_ride_by_driver_id():
        # Lấy driver_id từ tham số truyền vào URL
        driver_id = request.args.get('driver_id')
        if not driver_id:
            abort(400, description="Bad request: No driver_id provided.")
    
        # Gọi phương thức get_cab_ride_by_driver_id_from_db từ UserService
        cab_ride = user_service.get_cab_ride_by_driver_id_from_db(driver_id)
    
        if cab_ride:
            return jsonify(cab_ride.to_json()), 200
        else:
            return jsonify({"message": "No cab ride found for the given driver_id"}), 404

    # Hàm cập nhật điểm đánh giá (evaluate) dựa trên cab_ride_id
    @staticmethod
    def update_cab_ride_evaluate():
        # Lấy cab_ride_id và evaluate từ body của request
        data = request.json
        cab_ride_id = data.get('cab_ride_id')
        evaluate = data.get('evaluate')

        if not cab_ride_id or evaluate is None:
            abort(400, description="Bad request: cab_ride_id and evaluate are required.")
        
        # Kiểm tra giá trị evaluate có hợp lệ hay không (từ 0 đến 5)
        if not (0 <= evaluate <= 5):
            abort(400, description="Invalid evaluate value. It must be between 0 and 5.")

        # Gọi phương thức update_cab_ride_evaluate từ UserService
        updated_rows = user_service.update_cab_ride_evaluate(cab_ride_id, evaluate)
        
        if updated_rows > 0:
            return jsonify({"message": "Evaluate updated successfully!"}), 200
        else:
            return jsonify({"message": "Failed to update evaluate."}), 404
 # Hàm lấy thông tin xe taxi dựa trên driver_id
    @staticmethod
    def get_cab_by_driver_id():
        # Lấy driver_id từ tham số truyền vào URL
        driver_id = request.args.get('driver_id')
        if not driver_id:
            abort(400, description="Bad request: No driver_id provided.")
        # Gọi phương thức get_cab_by_driver_id từ UserService
        cab = user_service.get_cab_by_driver_id(driver_id)
        if cab:
            return jsonify(cab.to_json()), 200  # Trả về thông tin của xe dưới dạng JSON
        else:
            return jsonify({"message": "No cab found for the given driver_id"}), 404
 # Hàm lấy thông tin tài xế dựa trên driver_id
    @staticmethod
    def get_driver_by_id():
        # Lấy driver_id từ tham số truyền vào URL
        driver_id = request.args.get('driver_id')
        if not driver_id:
            abort(400, description="Bad request: No driver_id provided.")
        
        # Gọi phương thức get_driver_by_id từ UserService
        driver = user_service.get_driver_by_id(driver_id)
        
        if driver:
            return jsonify(driver.to_json()), 200  # Trả về thông tin tài xế dưới dạng JSON
        else:
            return jsonify({"message": "No driver found for the given driver_id"}), 404
# Hàm lấy thông tin đánh giá (evaluate) dựa trên driver_id
    @staticmethod
    def get_evaluate_by_driver_id():
        # Lấy driver_id từ tham số truyền vào URL
        driver_id = request.args.get('driver_id')
        if not driver_id:
            abort(400, description="Bad request: No driver_id provided.")
    
        # Gọi phương thức get_evaluate_by_driver_id từ UserService
        evaluate = user_service.get_evaluate_by_driver_id(driver_id)
    
        if evaluate is not None:
            return jsonify({"evaluate": evaluate}), 200
        else:
            return jsonify({"message": "No evaluate found for the given driver_id"}), 404
 # Hàm hủy chuyến đi dựa trên user_id và booking_id mới nhất
    @staticmethod
    def cancel_latest_booking():
        # Lấy user_id từ body của request
        user_data = request.json
        user_id = user_data.get('user_id')
        if not user_id:
            abort(400, description="Bad request: No user_id provided.")
        
        # Gọi phương thức cancel_latest_booking từ UserService
        cancelled_rows = user_service.cancel_latest_booking(user_id)
        
        if cancelled_rows > 0:
            return jsonify({"message": "Latest booking cancelled successfully!"}), 200
        else:
            return jsonify({"message": "No booking found or failed to cancel booking."}), 404