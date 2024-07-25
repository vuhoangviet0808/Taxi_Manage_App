// ignore_for_file: non_constant_identifier_names
import 'dart:ffi';
class User {
  int User_ID;
  String firstname;
  String lastname;
  String SDT;
  double Wallet;
  String DOB;
  String gender;
  String Address;
  String CCCD;

  User({
    required this.User_ID,
    required this.firstname,
    required this.lastname,
    required this.SDT,
    required this.Wallet,
    required this.DOB,
    required this.gender,
    required this.Address,
    required this.CCCD,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      User_ID: json['User_ID'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      SDT: json['SDT'],
      Wallet: (json['Wallet'] as num).toDouble(),
      DOB: json['DOB'],
      gender: json['gender'],
      Address: json['Address'],
      CCCD: json['CCCD'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'User_ID': User_ID,
      'firstname': firstname,
      'lastname': lastname,
      'SDT': SDT,
      'Wallet': Wallet.toInt(),
      'DOB': DOB,
      'gender': gender,
      'Address': Address,
      'CCCD': CCCD,
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
  final int canceled;
  final int payment_type_id;
  final double price;
  final String response;
  final String evaluate;

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
    required this.canceled,
    required this.payment_type_id,
    required this.price,
    required this.response,
    required this.evaluate,
  });

  factory CabRide.fromJson(Map<String, dynamic> json) {
    return CabRide(
      id: json['id'],
      shift_id: json['shift_id'],
      user_id: json['user_id'],
      ride_start_time: json['ride_start_time'],
      ride_end_time: json['ride_end_time'],
      address_starting_point: json['address_starting_point'],
      GPS_starting_point: json['GPS_starting_point'],
      address_destination: json['address_destination'],
      GPS_destination: json['GPS_destination'],
      canceled: json['canceled'],
      payment_type_id: json['payment_type_id'],
      price: double.parse(json['price'].toString()),
      response: json['response'],
      evaluate: json['evaluate'],
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
      'canceled': canceled,
      'payment_type_id': payment_type_id,
      'price': price,
      'response': response,
      'evaluate': evaluate,
    };
  }
}