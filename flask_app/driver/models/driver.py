class Driver:
    def __init__(self, driver_id, firstname, lastname, sdt, wallet, dob, gender, address, cccd, driving_license, working_experiment):
        self.driver_id = driver_id
        self.firstname = firstname
        self.lastname = lastname
        self.sdt = sdt
        self.wallet = wallet
        self.dob = dob
        self.gender = gender
        self.address = address
        self.cccd = cccd
        self.driving_license = driving_license
        self.working_experiment = working_experiment
    @staticmethod
    def from_dict(source):
        # Convert from dictionary to Driver object
        driver = Driver(
        driver_id=source.get('Driver_ID'),
        firstname=source.get('firstname'),
        lastname=source.get('lastname'),
        sdt=source.get('SDT'),
        wallet=source.get('Wallet'),
        dob=source.get('DOB'),
        gender=source.get('gender'),
        address=source.get('Address'),
        cccd=source.get('CCCD'),
        driving_license=source.get('Driving_license'),
        working_experiment=source.get('Working_experiment')
        )
        print(f"Created driver object: {driver}")
        return driver
    
class Shift:
    def __init__(self, id, driver_id, cab_id, shift_start_time, shift_end_time, login_time, logout_time):
        self.id = id
        self.driver_id = driver_id
        self.cab_id = cab_id
        self.shift_start_time = shift_start_time
        self.shift_end_time = shift_end_time
        self.login_time = login_time
        self.logout_time = logout_time
    @staticmethod
    def from_dict(data):
        return Shift(
            id=data.get('ID'),
            driver_id=data.get('Driver_id'),
            cab_id=data.get('cab_id'),
            shift_start_time=data.get('shift_start_time'),
            shift_end_time=data.get('shift_end_time'),
            login_time=data.get('login_time'),
            logout_time=data.get('logout_time')
        )
    
class CarModel:
    def __init__(self, id, model_name, model_description):
        self.id = id
        self.model_name = model_name
        self.model_description = model_description
    @staticmethod
    def from_dict(data):
        return CarModel(
            id = data.get('ID'),
            model_name = data.get('model_name'),
            model_description = data.get('model_description')
        )
    
class cabModel:
    def __init__(self, id, license_plate, car_model_id, manufacture_year, active):
        self.id = id
        self.license_plate = license_plate
        self.car_model_id = car_model_id
        self.manufacture_year = manufacture_year
        self.active = active
    @staticmethod
    def from_dict(data):
        return cabModel(
            id = data.get('ID'),
            license_plate= data.get('licence_plate'),
            car_model_id= data.get('car_model_id'),
            manufacture_year= data.get('manufacture_year'),
            active= data.get('active')
        )
class CabRide:
    def __init__(self, id, shift_id, user_id, ride_start_time, ride_end_time, address_starting_point, GPS_starting_point, address_destination, GPS_destination, canceled, payment_type_id, price, response, evaluate):
        self.id = id
        self.shift_id = shift_id
        self.user_id = user_id
        self.ride_start_time = ride_start_time
        self.ride_end_time = ride_end_time
        self.address_starting_point = address_starting_point
        self.GPS_starting_point = GPS_starting_point
        self.address_destination = address_destination
        self.GPS_destination = GPS_destination
        self.canceled = canceled
        self.payment_type_id = payment_type_id
        self.price = price
        self.response = response
        self.evaluate = evaluate
    
    @staticmethod
    def from_dict(data):
        return CabRide(
            id=data.get('ID'),
            shift_id=data.get('shift_id'),
            user_id=data.get('user_id'),
            ride_start_time=data.get('ride_start_time'),
            ride_end_time=data.get('ride_end_time'),
            address_starting_point=data.get('address_starting_point'),
            GPS_starting_point=data.get('GPS_starting_point'),
            address_destination=data.get('address_destination'),
            GPS_destination=data.get('GPS_destination'),
            canceled=data.get('canceled'),
            payment_type_id=data.get('payment_type_id'),
            price=data.get('price'),
            response=data.get('response'),
            evaluate=data.get('evaluate')
        )