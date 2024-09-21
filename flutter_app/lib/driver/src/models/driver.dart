// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:ffi';

import 'package:flutter/material.dart';

class Driver {
  int Driver_ID;
  String firstname;
  String lastname;
  String SDT;
  double Wallet;
  String DOB;
  String gender;
  String Address;
  String CCCD;
  String Driving_license;
  double Working_experiment;

  Driver(
      {required this.Driver_ID,
      required this.firstname,
      required this.lastname,
      required this.SDT,
      required this.Wallet,
      required this.DOB,
      required this.gender,
      required this.Address,
      required this.CCCD,
      required this.Driving_license,
      required this.Working_experiment});

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      Driver_ID: json['Driver_ID'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      SDT: json['SDT'],
      Wallet: double.tryParse(json['Wallet'].toString()) ?? 0.0,
      DOB: json['DOB'],
      gender: json['gender'],
      Address: json['Address'],
      CCCD: json['CCCD'],
      Driving_license: json['Driving_license'],
      Working_experiment:
          double.tryParse(json['Working_experiment'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Driver_ID': Driver_ID,
      'firstname': firstname,
      'lastname': lastname,
      'SDT': SDT,
      'Wallet': Wallet,
      'DOB': DOB,
      'gender': gender,
      'Address': Address,
      'CCCD': CCCD,
      'Driving_license': Driving_license,
      'Working_experiment': Working_experiment
    };
  }
}

class GPSlocation {
  final double latitude;
  final double
      longitude; // Sửa tên trường từ 'longtitude' thành 'longitude' cho đúng chính tả

  GPSlocation({required this.latitude, required this.longitude});

  factory GPSlocation.fromJson(Map<String, dynamic> json) {
    return GPSlocation(
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0, // Đảm bảo không có giá trị null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
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
  final GPSlocation GPS_starting_point;
  final String address_destination;
  final GPSlocation GPS_destination;
  final String? cancelled_by;
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
    required this.cancelled_by,
    required this.price,
    required this.response,
    required this.evaluate,
  });

  factory CabRide.fromJson(Map<String, dynamic> json) {
    return CabRide(
      id: json['id'],
      shift_id: json['shift_id'],
      user_id: json['user_id'],
      ride_start_time: json[
          'ride_start_time'], // Nếu cần, sử dụng DateTime.parse(json['ride_start_time'])
      ride_end_time: json[
          'ride_end_time'], // Nếu cần, sử dụng DateTime.parse(json['ride_end_time'])
      address_starting_point: json['address_starting_point'],
      GPS_starting_point: GPSlocation.fromJson(json['GPS_starting_point']),
      address_destination: json['address_destination'],
      GPS_destination: GPSlocation.fromJson(json['GPS_destination']),
      cancelled_by: json['cancelled_by'],
      price: json['price'] != null
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : 0.0, // Ép kiểu trực tiếp nếu không phải String
      response: json['response'],
      evaluate: json['evaluate'] != null
          ? double.tryParse(json['evaluate'].toString()) ?? 0.0
          : 0.0, // Ép kiểu trực tiếp nếu không phải String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shift_id': shift_id,
      'user_id': user_id,
      'ride_start_time':
          ride_start_time, // Nếu cần, sử dụng ride_start_time.toIso8601String()
      'ride_end_time':
          ride_end_time, // Nếu cần, sử dụng ride_end_time.toIso8601String()
      'address_starting_point': address_starting_point,
      'GPS_starting_point': GPS_starting_point.toJson(),
      'address_destination': address_destination,
      'GPS_destination': GPS_destination.toJson(),
      'cancelled_by': cancelled_by,
      'price': price,
      'response': response,
      'evaluate': evaluate,
    };
  }
}
