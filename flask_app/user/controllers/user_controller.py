from ..services.user_service import UserService
from flask import request, jsonify , abort



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
                'firstname': user["Firstname"],
                'lastname': user["Lastname"],
                'SDT': user["SDT"],
                'Wallet': user["Wallet"],
                'DOB': user["DOB"],
                'gender': user['Gender'],
                'Address': user['Address'],
                'CCCD': user['CCCD']
            }), 200
        else:
            abort(404, description="User not found.")