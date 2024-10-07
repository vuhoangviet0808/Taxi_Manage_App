class BookingRequest:
    def __init__(self, pickup_location, request_time, status):
        self.pickup_location = pickup_location
        self.request_time = request_time
        self.status = status

class FullBookingRequest:
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

    def __str__(self):
        return f"BookingRequest({self.booking_id}, {self.pickup_location}, {self.status})"