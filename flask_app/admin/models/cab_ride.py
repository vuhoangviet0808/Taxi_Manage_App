
class CabRide:
    def __init__(self, ID, shift_id, user_id, ride_start_time, ride_end_time, 
                 address_starting_point, GPS_starting_point, 
                 address_destination, GPS_destination, status, cancelled_by, 
                 price, response, evaluate):
        self.ID = ID
        self.shift_id = shift_id
        self.user_id = user_id
        self.ride_start_time = ride_start_time
        self.ride_end_time = ride_end_time
        self.address_starting_point = address_starting_point
        self.GPS_starting_point = GPS_starting_point
        self.address_destination = address_destination
        self.GPS_destination = GPS_destination
        self.status = status  # 'in_progress', 'cancelled', 'completed'
        self.cancelled_by = cancelled_by  # 'user', 'driver', 'system', or None if not cancelled
        self.price = price
        self.response = response
        self.evaluate = evaluate  # Rating for the ride (DECIMAL 2,1)
        
    def __repr__(self):
        return f"<CabRide {self.ID}, Status: {self.status}, Price: {self.price}, Evaluate: {self.evaluate}>"