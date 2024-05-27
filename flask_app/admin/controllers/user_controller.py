from flask import jsonify, abort
from ..services.user_services import UserService

user_service = UserService()

class UserController:
    def get_2_user_info(self):
        users = user_service.get_user_by_ID_and_name()
        if users:
            user_info = []
            for user in users:
                user_info.append({
                    'Firstname': user["Firstname"],
                    'Lastname': user["Lastname"],
                    'User_ID': user["User_ID"]
                })
            return jsonify(user_info), 200
        else:
            abort(404, description="No users found.")

    def get_full_user_info(self, User_ID):
        users = user_service.get_user_by_all(User_ID)
        if users:
            user_info = []
            for user in users:
                user_info.append({
                    'User_ID': user["User_ID"],
                    'SDT': user["SDT"],
                    'Firstname': user["Firstname"],
                    'Lastname': user["Lastname"],
                    'Wallet': user["Wallet"],
                    'DOB': user["DOB"],
                    'Gender': user["Gender"],
                    'Address': user["Address"],
                    'CCCD': user["CCCD"],
                    'created_at': user["created_at"],
                })
            return jsonify(user_info), 200
        else:
            abort(404, description="No users found.")