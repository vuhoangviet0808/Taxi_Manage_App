// ignore_for_file: camel_case_types, non_constant_identifier_names

class Cab_ride {
  final String ID;
  final String ride_start_time;

  Cab_ride(this.ID, this.ride_start_time);
}

class FullCabRide {
  final String ID;
  final String shift_id;
  final String user_id;
  final String ride_start_time;
  final String ride_end_time;
  final String address_starting_point;
  final String GPS_starting_point;
  final String address_destination;
  final String GPS_destination;
  final String canceled;
  final String payment_type_id;
  final String price;
  final String response;
  final String evaluate;

  FullCabRide(
    this.ID,
    this.shift_id,
    this.user_id,
    this.ride_start_time,
    this.ride_end_time,
    this.address_starting_point,
    this.GPS_starting_point,
    this.address_destination,
    this.GPS_destination,
    this.canceled,
    this.payment_type_id,
    this.price,
    this.response,
    this.evaluate,
  );
}
