// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/admin/models/shift_model.dart';

class ShiftService {
  Future<List<Shift>> fetchShift() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5000/admin/shifts'));

    if (response.statusCode == 200) {
      List<dynamic> shiftsData = json.decode(response.body);
      List<Shift> shiftInfo = [];

      for (var shiftData in shiftsData) {
        if (shiftData['ID'] != null && shiftData['shift_start_time'] != null) {
          String shiftID = shiftData['ID'].toString();
          shiftInfo.add(Shift(shiftID, shiftData['shift_start_time']));
        } else {
          print('Null data received for a cab ride: $shiftData');
        }
      }
      return shiftInfo;
    } else {
      print('Error parsing shifts data:');
      throw Exception('Failed to parse shifts data');
    }
  }

  Future<FullShift> fetchEachShift(String ID) async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5000/admin/shifts/$ID'));

    if (response.statusCode == 200) {
      dynamic responseBody = json.decode(response.body);

      if (responseBody is List) {
        // Nếu response body là một danh sách, lấy phần tử đầu tiên
        if (responseBody.isNotEmpty) {
          responseBody = responseBody.first;
        } else {
          print('Empty list received for the shift with ID: $ID');
          throw Exception('Empty list received for the shift');
        }
      }

      if (responseBody is Map<String, dynamic>) {
        // Tiếp tục giải mã body của response
        if (responseBody['ID'] != null) {
          return FullShift(
            responseBody['ID'].toString(),
            responseBody['Driver_id'].toString(),
            responseBody['cab_id']?.toString() ?? '',
            responseBody['shift_start_time']?.toString() ?? '',
            responseBody['shift_end_time']?.toString() ?? '',
            responseBody['login_time']?.toString() ?? '',
            responseBody['logout_time']?.toString() ?? '',
          );
        } else {
          print('Null data received for the shift with ID: $ID');
          throw Exception('Null data received for the shift');
        }
      } else {
        print('Invalid data type received for the shift with ID: $ID');
        throw Exception('Invalid data type received for the shift');
      }
    } else {
      throw Exception('Failed to load shift with ID: $ID');
    }
  }
}
