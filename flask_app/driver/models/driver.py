from decimal import Decimal
from datetime import datetime

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
    def __init__(self, id, driver_id, cab_id, current_gps_location, current_address, evaluate):
        self.id = id
        self.driver_id = driver_id
        self.cab_id = cab_id
        self.current_gps_location = current_gps_location
        self.current_address = current_address
        self.evaluate = evaluate

    @staticmethod
    def from_dict(data):
        return Shift(
            id=data.get('ID'),
            driver_id=data.get('Driver_id'),
            cab_id=data.get('cab_id'),
            current_gps_location=data.get('current_gps_location'),
            current_address=data.get('current_address'),
            evaluate=float(data.get('evaluate'))
        )

class Cab:
    def __init__(self, id, license_plate, car_type, manufacture_year, active):
        self.id = id
        self.license_plate = license_plate
        self.car_type = car_type
        self.manufacture_year = manufacture_year
        self.active = active
    
    @staticmethod
    def from_dict(data):
        return Cab(
            id=data.get('ID'),
            license_plate=data.get('licence_plate'),
            car_type=data.get('car_type'),
            manufacture_year=data.get('manufacture_year'),
            active=data.get('active')
        )

class CabRide:
    def __init__(self, id, shift_id, user_id, ride_start_time, ride_end_time, address_starting_point, GPS_starting_point, address_destination, GPS_destination, status, cancelled_by, price, response, evaluate):
        self.id = id
        self.shift_id = shift_id
        self.user_id = user_id
        self.ride_start_time = ride_start_time
        self.ride_end_time = ride_end_time
        self.address_starting_point = address_starting_point
        self.GPS_starting_point = GPS_starting_point
        self.address_destination = address_destination
        self.GPS_destination = GPS_destination
        self.status = status
        self.cancelled_by = cancelled_by
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
            status=data.get('status'),
            cancelled_by=data.get('cancelled_by'),
            price=float(data.get('price')) if data.get('price') is not None else 0.0,
            response=data.get('response'),
            evaluate=float(data.get('evaluate')) if data.get('evaluate') is not None else 0.0
        )

    def to_dict(self):
        return {
            'id': self.id,
            'shift_id': self.shift_id,
            'user_id': self.user_id,
            'ride_start_time': self.ride_start_time.isoformat() if isinstance(self.ride_start_time, datetime) else self.ride_start_time,
            'ride_end_time': self.ride_end_time.isoformat() if isinstance(self.ride_end_time, datetime) else self.ride_end_time,
            'address_starting_point': self.address_starting_point,
            'GPS_starting_point': self.GPS_starting_point,  # Assuming this is already a serializable type
            'address_destination': self.address_destination,
            'GPS_destination': self.GPS_destination,  # Assuming this is already a serializable type
            'status': self.status,
            'cancelled_by': self.cancelled_by,
            'price': float(self.price) if isinstance(self.price, Decimal) else self.price,
            'response': self.response,
            'evaluate': float(self.evaluate) if isinstance(self.evaluate, Decimal) else self.evaluate
        }
