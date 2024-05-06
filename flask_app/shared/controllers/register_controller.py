from flask import request, jsonify
from ..services.register_service import RegisterService

register_service = RegisterService()

def register():
    sdt = request.json.get('SDT')
    password = request.json.get('password')
    if(register_service.check_phone(sdt)):
        account = register_service.register_new_user(sdt, password)
        if account:
            return jsonify({
                'Message': 'Registration successful',
                'sdt': sdt
            }), 200
    return jsonify({
        'Message': 'Phone number already registered'
    }), 400    
    
        
