import 'dart:convert';
import 'package:http/http.dart' as http;

class DriverSearchService {
  final String baseUrl = 'http://10.0.2.2:5000/admin/drivers_in_bounding_box';

  Future<List<Map<String, dynamic>>> fetchDriversForBookingRequest(
      String bookingId) async {
    final response = await http.get(Uri.parse('$baseUrl/$bookingId'));

    if (response.statusCode == 200) {
      List<dynamic> driverData = json.decode(response.body);
      List<Map<String, dynamic>> drivers = [];

      for (var driver in driverData) {
        if (driver['Shift_ID'] != null && driver['Driver_ID'] != null) {
          drivers.add({
            'Shift_ID': driver['Shift_ID'].toString(),
            'Driver_ID': driver['Driver_ID'].toString(),
          });
        } else {
          print('Null data received for driver: $driver');
        }
      }

      return drivers;
    } else {
      print('Error fetching drivers data: ${response.statusCode}');
      throw Exception('Failed to fetch drivers');
    }
  }
}
