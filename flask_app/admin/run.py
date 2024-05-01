from flask import Flask
from controllers.driver_controller import driver_blueprint
from controllers.order_controller import order_blueprint

app = Flask(__name__)

# Đăng ký blueprint
app.register_blueprint(driver_blueprint)
app.register_blueprint(order_blueprint)
if __name__ == '__main__':
    app.run(debug=True)