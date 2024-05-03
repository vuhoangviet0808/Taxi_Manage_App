from ..services.auth_service import AuthService
from flask import request, jsonify 

auth_service = AuthService()

def login():
    sdt = request.json.get('SDT')
    password = request.json.get('password')
    account = auth_service.authenticate(sdt, password)
    if account:
        return jsonify({
            'message': 'Login successful',
            'SDT': account['SDT'], 
            'password': account['password'],
            'role': account['roles'],
            'status': account['status']
            }), 200
    return jsonify({'message': 'Invalid username or password'}), 401

