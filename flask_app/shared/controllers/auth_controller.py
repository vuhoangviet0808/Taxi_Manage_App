from ..services.auth_service import AuthService
from flask import request, jsonify

auth_service = AuthService()

def login():
    username = request.json.get('username')
    password = request.json.get('password')
    account = auth_service.authenticate(username, password)
    if account:
        return jsonify({'message': 'Login successful','id': '1', 'username': username,'email': "vuotngokhong@gmail.com"}), 200
    return jsonify({'message': 'Invalid username or password'}), 401

