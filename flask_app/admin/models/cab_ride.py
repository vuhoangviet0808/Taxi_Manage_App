class cab_ride:
    def __init__(self, ID, shift_id, user_id, ride_start_time, ride_end_time, address_starting_point, GPS_starting_point, address_destination, GPS_destination, canceled, payment_type_id, price, response,  evaluate):
        self.ID = ID
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