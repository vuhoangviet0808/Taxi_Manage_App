from flask import Flask
from .views.auth_views import auth_blueprint

def create_login():
    app = Flask(__name__)
    app.register_blueprint(auth_blueprint)
    return app
