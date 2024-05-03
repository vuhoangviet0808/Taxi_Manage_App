from flask import Flask
from user.views.user_views import user_blueprint
from shared.views.auth_views import auth_blueprint
from driver.views.driver_views import driver_blueprint
from admin.views.admin_views import admin_blueprint

app = Flask(__name__)

app.register_blueprint(admin_blueprint, url_prefix='/admin')
app.register_blueprint(driver_blueprint, url_prefix='/driver')
app.register_blueprint(user_blueprint, url_prefix='/user')
app.register_blueprint(auth_blueprint, url_prefix='/')

if __name__ == '__main__':
    app.run(debug=True)