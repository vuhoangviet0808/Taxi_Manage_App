class DriverBooking:
    def __init__(self, booking_id, driver_id, status):
        self.booking_id = booking_id
        self.driver_id = driver_id
        self.status = status

    def __str__(self):
        return f"DriverBooking(booking_id={self.booking_id}, driver_id={self.driver_id}, status={self.status})"