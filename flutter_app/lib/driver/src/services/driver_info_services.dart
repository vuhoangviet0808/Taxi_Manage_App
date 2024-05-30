import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/driver.dart';

const String baseUrl = 'http://10.0.2.2:5000';

class DriverInfoService {
  Future<Driver?> getDriverInfo(String sdt) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/driver/getinfo?phone=$sdt'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Driver driver = Driver.fromJson(jsonDecode(response.body));
        return driver;
      } else {
        throw Exception(
            'Failed to get information. Error code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}

class DriverUpdateService {
  Future<bool> updateDriverInfo(Driver driver) async {
    try {
      print("Sending Data: ${driver.toJson()}");
      final response = await http.post(
          Uri.parse('$baseUrl/driver/update_driver_infor'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(driver.toJson()));
      print('Received response: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        print("Update Success");
        return true;
      } else {
        print("Failed");
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}

class CabRideInfoService {
  Future<List<CabRide>> getCabRide(int driverID) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/driver/getCabRide?driver_id=$driverID'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => CabRide.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception(
            'Failed to get information. Error code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}
