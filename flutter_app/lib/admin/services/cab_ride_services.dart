// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/admin/models/cab_ride_model.dart';

class CabRideService {
  Future<List<Cab_ride>> fetchCabRide() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5000/admin/cab_rides'));

    if (response.statusCode == 200) {
      List<dynamic> cabRidesData = json.decode(response.body);
      List<Cab_ride> cabRideInfo = [];

      for (var cabRideData in cabRidesData) {
        if (cabRideData['ID'] != null &&
            cabRideData['ride_start_time'] != null) {
          String CabRideID = cabRideData['ID'].toString();
          cabRideInfo.add(Cab_ride(CabRideID, cabRideData['ride_start_time']));
        } else {
          print('Null data received for a cab ride: $cabRideData');
        }
      }
      return cabRideInfo;
    } else {
      print('Error parsing cab rides data:');
      throw Exception('Failed to parse cab rides data');
    }
  }

  Future<FullCabRide> fetchEachCabRide(String cabRideID) async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:5000/admin/cab_rides/$cabRideID'));

    if (response.statusCode == 200) {
      dynamic responseBody = json.decode(response.body);

      if (responseBody is List) {
        if (responseBody.isNotEmpty) {
          responseBody = responseBody.first;
        } else {
          print('Empty list received for the cab ride with ID: $cabRideID');
          throw Exception('Empty list received for the cab ride');
        }
      }

      if (responseBody is Map<String, dynamic>) {
        if (responseBody['ID'] != null) {
          return FullCabRide(
              responseBody['ID'].toString(),
              responseBody['shift_ID'].toString(),
              responseBody['user_ID']?.toString() ?? '',
              responseBody['ride_start_time']?.toString() ?? '',
              responseBody['ride_end_time']?.toString() ?? '',
              responseBody['address_starting_point']?.toString() ?? '',
              responseBody['GPS_starting_point']?.toString() ?? '',
              responseBody['address_destination']?.toString() ?? '',
              responseBody['GPS_destination']?.toString() ?? '',
              responseBody['canceled']?.toString() ?? '',
              responseBody['payment_type_id']?.toString() ?? '',
              responseBody['price']?.toString() ?? '',
              responseBody['response']?.toString() ?? '',
              responseBody['evaluate']?.toString() ?? '');
        } else {
          print('Null data received for the cab ride with ID: $cabRideID');
          throw Exception('Null data received for the cab ride');
        }
      } else {
        print(
            'Invalid data type received for the cab ride with ID: $cabRideID');
        throw Exception('Invalid data type received for the cab ride');
      }
    } else {
      throw Exception('Failed to load cab ride with ID: $cabRideID');
    }
  }
}
