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