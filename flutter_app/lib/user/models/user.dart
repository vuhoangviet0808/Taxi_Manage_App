class User {
  int User_ID;
  String SDT;
  String firstname;
  String lastname;
  double Wallet;
  String DOB;
  String Gender;
  String Address;
  String CCCD;
  String user_token;

  User({
    required this.User_ID,
    required this.SDT,
    required this.firstname,
    required this.lastname,
    required this.Wallet,
    required this.DOB,
    required this.Gender,
    required this.Address,
    required this.CCCD,
    required this.user_token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      User_ID: json['User_ID'] ?? 0,  // Default to 0 if null
      SDT: json['SDT'] ?? '',  // Default to empty string if null
      firstname: json['firstname'] ?? '',  // Default to empty string if null
      lastname: json['lastname'] ?? '',  // Default to empty string if null
      Wallet: json['Wallet'] != null ? double.tryParse(json['Wallet'].toString()) ?? 0.0 : 0.0,
      DOB: json['DOB'] ?? '',  // Default to empty string if null
      Gender: json['Gender'] ?? '',  // Default to empty string if null
      Address: json['Address'] ?? '',  // Default to empty string if null
      CCCD: json['CCCD'] ?? '',  // Default to empty string if null
      user_token: json['user_token'] ?? '',  // Default to empty string if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'User_ID': User_ID,
      'SDT': SDT,
      'firstname': firstname,
      'lastname': lastname,
      'Wallet': Wallet.toInt(),
      'DOB': DOB,
      'Gender': Gender,
      'Address': Address,
      'CCCD': CCCD,
      'user_token': user_token,
    };
  }
}

class CabRide {
  final int id;
  final int shift_id;
  final int user_id;
  final String ride_start_time;
  final String ride_end_time;
  final String address_starting_point;
  final String GPS_starting_point;
  final String address_destination;
  final String GPS_destination;
  final String status;
  final String cancelled_by;
  final double price;
  final String response;
  final double evaluate;

  CabRide({
    required this.id,
    required this.shift_id,
    required this.user_id,
    required this.ride_start_time,
    required this.ride_end_time,
    required this.address_starting_point,
    required this.GPS_starting_point,
    required this.address_destination,
    required this.GPS_destination,
    required this.status,
    required this.cancelled_by,
    required this.price,
    required this.response,
    required this.evaluate,
  });

  factory CabRide.fromJson(Map<String, dynamic> json) {
    return CabRide(
      id: json['id'] ?? 0,  // Default to 0 if null
      shift_id: json['shift_id'] ?? 0,  // Default to 0 if null
      user_id: json['user_id'] ?? 0,  // Default to 0 if null
      ride_start_time: json['ride_start_time'] ?? '',  // Default to empty string if null
      ride_end_time: json['ride_end_time'] ?? '',  // Default to empty string if null
      address_starting_point: json['address_starting_point'] ?? '',  // Default to empty string if null
      GPS_starting_point: json['GPS_starting_point'] ?? '',  // Default to empty string if null
      address_destination: json['address_destination'] ?? '',  // Default to empty string if null
      GPS_destination: json['GPS_destination'] ?? '',  // Default to empty string if null
      status: json['status'] ?? '',  // Default to empty string if null
      cancelled_by: json['cancelled_by'] ?? '',  // Default to empty string if null
      price: json['price'] != null ? double.tryParse(json['price'].toString()) ?? 0.0 : 0.0,
      response: json['response'] ?? '',  // Default to empty string if null
      evaluate: json['evaluate'] != null ? double.tryParse(json['evaluate'].toString()) ?? 0.0 : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shift_id': shift_id,
      'user_id': user_id,
      'ride_start_time': ride_start_time,
      'ride_end_time': ride_end_time,
      'address_starting_point': address_starting_point,
      'GPS_starting_point': GPS_starting_point,
      'address_destination': address_destination,
      'GPS_destination': GPS_destination,
      'status': status,
      'cancelled_by': cancelled_by,
      'price': price,
      'response': response,
      'evaluate': evaluate,
    };
  }
}

class BookingRequest {
  final int booking_id;
  final int user_id;
  final String requested_car_type;
  final String pickup_location;
  final String dropoff_location;
  final String gps_pickup_location;
  final String gps_destination_location;
  final double price;
  final String request_time;
  final String status;
  final int driver_id;

  BookingRequest({
    required this.booking_id,
    required this.user_id,
    required this.requested_car_type,
    required this.pickup_location,
    required this.dropoff_location,
    required this.gps_pickup_location,
    required this.gps_destination_location,
    required this.price,
    required this.request_time,
    required this.status,
    required this.driver_id,
  });

  factory BookingRequest.fromJson(Map<String, dynamic> json) {
    return BookingRequest(
      booking_id: json['booking_id'] ?? 0,  // Default to 0 if null
      user_id: json['user_id'] ?? 0,  // Default to 0 if null
      requested_car_type: json['requested_car_type'] ?? '',  // Default to empty string if null
      pickup_location: json['pickup_location'] ?? '',  // Default to empty string if null
      dropoff_location: json['dropoff_location'] ?? '',  // Default to empty string if null
      gps_pickup_location: json['gps_pickup_location'] ?? '',  // Default to empty string if null
      gps_destination_location: json['gps_destination_location'] ?? '',  // Default to empty string if null
      price: json['price'] != null ? double.tryParse(json['price'].toString()) ?? 0.0 : 0.0,
      request_time: json['request_time'] ?? '',  // Default to empty string if null
      status: json['status'] ?? '',  // Default to empty string if null
      driver_id: json['driver_id'] ?? 0,  // Default to 0 if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': booking_id,
      'user_id': user_id,
      'requested_car_type': requested_car_type,
      'pickup_location': pickup_location,
      'dropoff_location': dropoff_location,
      'gps_pickup_location': gps_pickup_location,
      'gps_destination_location': gps_destination_location,
      'price': price,
      'request_time': request_time,
      'status': status,
      'driver_id': driver_id,
    };
  }
}

class BookingDriver {
  final int booking_id;
  final int driver_id;
  final String status;
  final String status_changed_at;

  BookingDriver({
    required this.booking_id,
    required this.driver_id,
    required this.status,
    required this.status_changed_at,
  });

  factory BookingDriver.fromJson(Map<String, dynamic> json) {
    return BookingDriver(
      booking_id: json['booking_id'] ?? 0,  // Default to 0 if null
      driver_id: json['driver_id'] ?? 0,  // Default to 0 if null
      status: json['status'] ?? '',  // Default to empty string if null
      status_changed_at: json['status_changed_at'] ?? '',  // Default to empty string if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': booking_id,
      'driver_id': driver_id,
      'status': status,
      'status_changed_at': status_changed_at,
    };
  }
}

class Driver {
  final int Driver_ID;
  final String SDT;
  final String Firstname;
  final String Lastname;
  final double Wallet;
  final String DOB;
  final String Gender;
  final String Address;
  final String CCCD;
  final String Driving_license_number;
  final double Working_experiment;
  final String driver_token;

  Driver({
    required this.Driver_ID,
    required this.SDT,
    required this.Firstname,
    required this.Lastname,
    required this.Wallet,
    required this.DOB,
    required this.Gender,
    required this.Address,
    required this.CCCD,
    required this.Driving_license_number,
    required this.Working_experiment,
    required this.driver_token,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      Driver_ID: json['Driver_ID'] ?? 0,  // Default to 0 if null
      SDT: json['SDT'] ?? '',  // Default to empty string if null
      Firstname: json['Firstname'] ?? '',  // Default to empty string if null
      Lastname: json['Lastname'] ?? '',  // Default to empty string if null
      Wallet: json['Wallet'] != null ? double.tryParse(json['Wallet'].toString()) ?? 0.0 : 0.0,
      DOB: json['DOB'] ?? '',  // Default to empty string if null
      Gender: json['Gender'] ?? '',  // Default to empty string if null
      Address: json['Address'] ?? '',  // Default to empty string if null
      CCCD: json['CCCD'] ?? '',  // Default to empty string if null
      Driving_license_number: json['Driving_licence_number'] ?? '',  // Default to empty string if null
      Working_experiment: json['Working_experiment'] != null ? double.tryParse(json['Working_experiment'].toString()) ?? 0.0 : 0.0,
      driver_token: json['driver_token'] ?? '',  // Default to empty string if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Driver_ID': Driver_ID,
      'SDT': SDT,
      'Firstname': Firstname,
      'Lastname': Lastname,
      'Wallet': Wallet,
      'DOB': DOB,
      'Gender': Gender,
      'Address': Address,
      'CCCD': CCCD,
      'Driving_licence_number': Driving_license_number,
      'Working_experiment': Working_experiment,
      'driver_token': driver_token,
    };
  }
}

class Shift {
  final int id;
  final int driver_id;
  final int cab_id;
  final String current_gps_location;
  final String current_address;
  final double evaluate;

  Shift({
    required this.id,
    required this.driver_id,
    required this.cab_id,
    required this.current_gps_location,
    required this.current_address,
    required this.evaluate,
  });

  // Phương thức để khởi tạo đối tượng Shift từ JSON
  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['ID'] ?? 0,  // Default to 0 if null
      driver_id: json['Driver_id'] ?? 0,  // Default to 0 if null
      cab_id: json['cab_id'] ?? 0,  // Default to 0 if null
      current_gps_location: json['current_gps_location'] ?? '',  // Default to empty string if null
      current_address: json['current_address'] ?? '',  // Default to empty string if null
      evaluate: json['evaluate'] != null ? double.tryParse(json['evaluate'].toString()) ?? 0.0 : 0.0,  // Default to 0.0 if null
    );
  }

  // Phương thức để chuyển đổi đối tượng Shift thành JSON
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Driver_id': driver_id,
      'cab_id': cab_id,
      'current_gps_location': current_gps_location,
      'current_address': current_address,
      'evaluate': evaluate,
    };
  }
}class Cab {
  final int id;
  final String licence_plate;
  final String car_type;
  final int manufacture_year;
  final bool active;

  Cab({
    required this.id,
    required this.licence_plate,
    required this.car_type,
    required this.manufacture_year,
    required this.active,
  });

  // Phương thức để khởi tạo đối tượng Cab từ JSON
  factory Cab.fromJson(Map<String, dynamic> json) {
    return Cab(
      id: json['ID'] ?? 0,  // Default to 0 if null
      licence_plate: json['licence_plate'] ?? '',  // Default to empty string if null
      car_type: json['car_type'] ?? '',  // Default to empty string if null
      manufacture_year: json['manufacture_year'] ?? 0,  // Default to 0 if null
      active: json['active'] == 1,  // Chuyển đổi thành boolean
    );
  }

  // Phương thức để chuyển đổi đối tượng Cab thành JSON
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'licence_plate': licence_plate,
      'car_type': car_type,
      'manufacture_year': manufacture_year,
      'active': active ? 1 : 0,  // Chuyển đổi từ boolean thành 1 hoặc 0
    };
  }
}