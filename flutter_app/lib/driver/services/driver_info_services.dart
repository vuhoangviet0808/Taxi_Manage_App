import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/driver.dart';

class DriverInfoService {
  final String baseUrl = 'http://10.0.2.2:5000';

  Future<Driver?> getDriverInfo(String sdt) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/driver/getinfo?phone=$sdt'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if(response.statusCode == 200) {
        final Driver driver = Driver.fromJson(jsonDecode(response.body));
        return driver;
      } else {
        throw Exception('Failed to get information. Error code: ${response.statusCode}');
      }

    } catch (e) {
      throw Exception('$e');
    }
  }
}