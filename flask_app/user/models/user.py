import json
from datetime import datetime

class User:
    def __init__(self, user_id, firstname, lastname, sdt, wallet, dob, gender, address, cccd, user_token):
        self.user_id = user_id
        self.firstname = firstname
        self.lastname = lastname
        self.sdt = sdt
        self.wallet = wallet
        self.dob = dob
        self.gender = gender
        self.address = address
        self.cccd = cccd
        self.user_token = user_token  # Thêm thuộc tính user_token

    @staticmethod
    def from_dict(source):
        return User(
            user_id=source.get('User_ID'),
            firstname=source.get('firstname'),
            lastname=source.get('lastname'),
            sdt=source.get('SDT'),
            wallet=source.get('Wallet'),
            dob=source.get('DOB'),
            gender=source.get('Gender'),
            address=source.get('Address'),
            cccd=source.get('CCCD'),
            user_token=source.get('user_token')  # Lấy từ dict
        )

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
            evaluate=data.get('evaluate')
        )

    def to_json(self):
        return {
            'id': self.id,
            'driver_id': self.driver_id,
            'cab_id': self.cab_id,
            'current_gps_location': self.current_gps_location,
            'current_address': self.current_address,
            'evaluate': self.evaluate
        }

class Cab:
    def __init__(self, id, licence_plate, car_type, manufacture_year, active):
        self.id = id
        self.licence_plate = licence_plate
        self.car_type = car_type
        self.manufacture_year = manufacture_year
        self.active = active

    @staticmethod
    def from_dict(data):
        return Cab(
            id=data.get('ID'),
            licence_plate=data.get('licence_plate'),
            car_type=data.get('car_type'),
            manufacture_year=data.get('manufacture_year'),
            active=data.get('active')
        )

    def to_dict(self):
        return {
            'ID': self.id,
            'licence_plate': self.licence_plate,
            'car_type': self.car_type,
            'manufacture_year': self.manufacture_year,
            'active': self.active
        }

    def to_json(self):
        return {
            'id': self.id,
            'licence_plate': self.licence_plate,
            'car_type': self.car_type,
            'manufacture_year': self.manufacture_year,
            'active': self.active
        }

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
            ride_start_time=str(data.get('ride_start_time', '')),  # Chuyển thành chuỗi
            ride_end_time=str(data.get('ride_end_time', '')),      # Chuyển thành chuỗi
            address_starting_point=str(data.get('address_starting_point', '')),
            GPS_starting_point=str(data.get('GPS_starting_point', '')),
            address_destination=str(data.get('address_destination', '')),
            GPS_destination=str(data.get('GPS_destination', '')),
            status=str(data.get('status', '')),
            cancelled_by=str(data.get('cancelled_by', '')),
            price=float(data.get('price', 0)),  # Đảm bảo chuyển thành float
            response=str(data.get('response', '')),
            evaluate=float(data.get('evaluate', 0))  # Đảm bảo chuyển thành float
        )

    def to_json(self):
        return {
            'id': self.id,
            'shift_id': self.shift_id,
            'user_id': self.user_id,
            'ride_start_time': self.ride_start_time.isoformat() if isinstance(self.ride_start_time, datetime) else self.ride_start_time,
            'ride_end_time': self.ride_end_time.isoformat() if isinstance(self.ride_end_time, datetime) else self.ride_end_time,
            'address_starting_point': self.address_starting_point,
            'GPS_starting_point': self.GPS_starting_point,
            'address_destination': self.address_destination,
            'GPS_destination': self.GPS_destination,
            'status': self.status,
            'cancelled_by': self.cancelled_by,
            'price': self.price,
            'response': self.response,
            'evaluate': self.evaluate
        }

class BookingRequest:
    def __init__(self, booking_id, user_id, requested_car_type, pickup_location, dropoff_location, gps_pick_up_location, gps_destination_location, price, request_time, status, driver_id):
        self.booking_id = booking_id
        self.user_id = user_id
        self.requested_car_type = requested_car_type
        self.pickup_location = pickup_location
        self.dropoff_location = dropoff_location
        self.gps_pick_up_location = gps_pick_up_location
        self.gps_destination_location = gps_destination_location
        self.price = price
        self.request_time = request_time
        self.status = status
        self.driver_id = driver_id

    @staticmethod
    def from_dict(data):
        return BookingRequest(
            booking_id=data.get('booking_id'),
            user_id=data.get('user_id'),
            requested_car_type=data.get('requested_car_type', ''),
            pickup_location=data.get('pickup_location', ''),
            dropoff_location=data.get('dropoff_location', ''),
            gps_pick_up_location=data.get('gps_pick_up_location', ''),
            gps_destination_location=data.get('gps_destination_location', ''),
            price=float(data.get('price', 0)),  # Chuyển thành float
            request_time=str(data.get('request_time', '')),
            status=str(data.get('status', '')),
            driver_id=data.get('driver_id')
        )

    def to_json(self):
        return {
            'booking_id': self.booking_id,
            'user_id': self.user_id,
            'requested_car_type': self.requested_car_type,
            'pickup_location': self.pickup_location,
            'dropoff_location': self.dropoff_location,
            'gps_pick_up_location': self.gps_pick_up_location,
            'gps_destination_location': self.gps_destination_location,
            'price': self.price,
            'request_time': self.request_time.isoformat() if isinstance(self.request_time, datetime) else self.request_time,
            'status': self.status,
            'driver_id': self.driver_id
        }

class BookingDriver:
    def __init__(self, booking_id, driver_id, status, status_changed_at):
        self.booking_id = booking_id
        self.driver_id = driver_id
        self.status = status
        self.status_changed_at = status_changed_at

    @staticmethod
    def from_dict(data):
        return BookingDriver(
            booking_id=data.get('booking_id'),
            driver_id=data.get('driver_id'),
            status=str(data.get('status', '')),
            status_changed_at=str(data.get('status_changed_at', ''))
        )

    def to_json(self):
        return {
            'booking_id': self.booking_id,
            'driver_id': self.driver_id,
            'status': self.status,
            'status_changed_at': self.status_changed_at.isoformat() if isinstance(self.status_changed_at, datetime) else self.status_changed_at
        }
class Driver:
    def __init__(self, driver_id, sdt, firstname, lastname, wallet, dob, gender, address, cccd, driving_license_number, working_experiment, driver_token):
        self.driver_id = driver_id
        self.sdt = sdt
        self.firstname = firstname
        self.lastname = lastname
        self.wallet = wallet
        self.dob = dob
        self.gender = gender
        self.address = address
        self.cccd = cccd
        self.driving_license_number = driving_license_number
        self.working_experiment = working_experiment
        self.driver_token = driver_token

    @staticmethod
    def from_dict(data):
        return Driver(
            driver_id=data.get('Driver_ID'),
            sdt=data.get('SDT'),
            firstname=data.get('Firstname'),
            lastname=data.get('Lastname'),
            wallet=float(data.get('Wallet', 0.0)),  # Chuyển thành float
            dob=data.get('DOB'),
            gender=data.get('Gender'),
            address=data.get('Address'),
            cccd=data.get('CCCD'),
            driving_license_number=data.get('Driving_licence_number'),
            working_experiment=float(data.get('Working_experiment', 0.0)),  # Chuyển thành float
            driver_token=data.get('driver_token')
        )

    def to_json(self):
        return {
            'Driver_ID': self.driver_id,
            'SDT': self.sdt,
            'Firstname': self.firstname,
            'Lastname': self.lastname,
            'Wallet': self.wallet,
            'DOB': self.dob,
            'Gender': self.gender,
            'Address': self.address,
            'CCCD': self.cccd,
            'Driving_licence_number': self.driving_license_number,
            'Working_experiment': self.working_experiment,
            'driver_token': self.driver_token
        }