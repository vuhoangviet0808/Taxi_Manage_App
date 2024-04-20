from ..services.auth_service import AuthenticationService
from flask import request, jsonify

auth_service = AuthenticationService()

def login():
    username = request.json.get('username')
    password = request.json.get('password')
    user = auth_service.authenticate(username, password)
    if user:
        return jsonify({'message': 'Login successful', 'username': username}), 200
    return jsonify({'message': 'Invalid username or password'}), 401
