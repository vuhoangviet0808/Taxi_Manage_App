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
}
