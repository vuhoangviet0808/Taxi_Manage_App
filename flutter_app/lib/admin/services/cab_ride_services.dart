import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/admin/models/cab_ride_model.dart';

class CabRideService {
  Future<List<Cab_ride>> fetchCabRide() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5000/admin/cab_rides'));
    if (response.statusCode == 200) {
      List<dynamic> cab_ridesData = json.decode(response.body);
      List<Cab_ride> cab_ride_info = [];
      for (var cab_rideData in cab_ridesData) {
        if (cab_rideData['ID'] != null &&
            cab_rideData['ride_start_time'] != null) {
          cab_ride_info.add(
              Cab_ride(cab_rideData['ID'], cab_rideData['ride_start_time']));
        } else {
          print('Null data received for a cab ride.');
        }
      }
      return cab_ride_info;
    } else {
      throw Exception('Failed to load cab rides');
    }
  }
}
