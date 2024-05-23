from flask import request, jsonify
from ..services.register_service import RegisterService

register_service = RegisterService()

class RegisterController:
    def register():
        sdt = request.json.get('SDT')
        password = request.json.get('password')
        if(register_service.check_phone(sdt)):
            account = register_service.register_new_user(sdt, password)
            if account:
                return jsonify({
                    'Message': 'Registration successful'
                }), 200
        return jsonify({
            'Message': 'Phone number already registered'
        }), 400    
    def register_input_info():
        sdt = request.json.get('SDT')
        firstname = request.json.get('firstname')
        lastname = request.json.get('lastname')
        sex = request.json.get('sex')
        DOB = request.json.get('DOB')
        CCCD = request.json.get('CCCD')
        if(register_service.input_info_new_user(sdt, firstname, lastname, sex, DOB, CCCD)):
            return jsonify({
                'Message': "Input successfully registered"
            }), 200
        return jsonify({
            'Message': 'Input failed'
        }), 400