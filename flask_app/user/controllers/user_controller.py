from ..models.user import User
from ..services.user_service import UserService
from flask import request, jsonify , abort
from datetime import datetime


user_service = UserService()
class UserController:
    def get_user_info():
        phone = request.args.get('phone')
        print(phone)
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
                
            }), 200
        else:
            abort(404, description="User not found.")
    @staticmethod
    def update_info():
        user_data = request.json
        print("Received data for update:", user_data)
        if not user_data:
            abort(400, description = "No data provided.")
        user = User.from_dict(user_data)
        print("Updating user:", user.firstname, user.lastname, user.address, user.cccd, user.dob)
        updated_rows = user_service.update_user_info(user)
        if updated_rows:
            return jsonify({"message": "User info updated successfully!"}), 200
        else:
            return jsonify({"message": "Failed to update user info."}), 404
   
    @staticmethod
    def car_model():
        car_id = request.args.get('car_model_id')
        if not car_id:
            abort(400, "Bad request: No car_model_id provided")
        car_model =  user_service.get_car_model(car_id)
        if car_model is None:
            abort(404, "No Information")
        return jsonify(car_model.__dict__)
    @staticmethod
    def cab():
        cabs = user_service.get_cab()
        if cabs is None:
            abort(404, "No cab")
        return jsonify([c.__dict__ for c in cabs]) 
    @staticmethod
    def cab_ride():
        user_id = request.args.get('user_id')
        if not user_id:
            abort(400, "Bad request: No user_id provided")
        cab_ride = user_service.get_cab_ride(user_id)
        if not cab_ride:
            abort(404, "No cab ride found for this user_id")
        return jsonify([ride.__dict__ for ride in cab_ride])