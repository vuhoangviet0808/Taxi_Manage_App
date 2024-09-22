class BookingRequest {
  final String booking_id;
  final String pickup_location;
  final String status;

  BookingRequest(this.booking_id, this.pickup_location, this.status);
}

class FullBookingRequest {
  final String booking_id;
  final String user_id;
  final String requested_car_type;
  final String pickup_location;
  final String pickup_latitude;
  final String pickup_longitude;
  final String dropoff_location;
  final String destination_latitude;
  final String destination_longitude;
  final String price;
  final String request_time;
  final String status;
  final String driver_id;

  FullBookingRequest(
    this.booking_id,
    this.user_id,
    this.requested_car_type,
    this.pickup_location,
    this.pickup_latitude,
    this.pickup_longitude,
    this.dropoff_location,
    this.destination_latitude,
    this.destination_longitude,
    this.price,
    this.request_time,
    this.status,
    this.driver_id,
  );
}
