class Shift:
    def __init__(self, ID, driver_id, cab_id, current_gps_location=None, current_address=None, evaluate=None):
        self.ID = ID
        self.driver_id = driver_id  # Renamed to follow Python naming conventions
        self.cab_id = cab_id
        self.current_gps_location = current_gps_location  # This should be a tuple (longitude, latitude) or None
        self.current_address = current_address
        self.evaluate = evaluate  # Nullable field

    def __repr__(self):
        return f"<Shift(ID={self.ID}, driver_id={self.driver_id}, cab_id={self.cab_id}, " \
               f"current_gps_location={self.current_gps_location}, current_address={self.current_address}, " \
               f"evaluate={self.evaluate})>"