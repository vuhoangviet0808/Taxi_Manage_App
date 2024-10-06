import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/admin/models/cab_model.dart';

class CabService {
  Future<List<Cab>> fetchCabs() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5000/admin/cabs'));
    if (response.statusCode == 200) {
      List<dynamic> cabsData = json.decode(response.body);
      List<Cab> cab_info = [];
      for (var cabData in cabsData) {
        if (cabData['ID'] != null && cabData['licence_plate'] != null) {
          String cabID = cabData['ID'].toString();
          cab_info.add(Cab(cabID, cabData['licence_plate']));
        } else {
          print('Null data received for a cab.');
        }
      }
      return cab_info;
    } else {
      throw Exception('Failed to load cabs');
    }
  }

  Future<FullCab> fetchEachCab(String cabID) async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5000/admin/cabs/$cabID'));

    if (response.statusCode == 200) {
      dynamic responseBody = json.decode(response.body);

      if (responseBody is List) {
        if (responseBody.isNotEmpty) {
          responseBody = responseBody.first;
        } else {
          print('Empty list received for the cab with ID: $cabID');
          throw Exception('Empty list received for the cab');
        }
      }

      if (responseBody is Map<String, dynamic>) {
        // Proceed with decoding the response body
        if (responseBody['ID'] != null) {
          String cabID = responseBody['ID'].toString();
          String carType = responseBody['car_type'].toString();
          String manufactureYear = responseBody['manufacture_year'].toString();
          String active = responseBody['active'].toString();

          return FullCab(
            cabID,
            responseBody['licence_plate'],
            carType,
            manufactureYear,
            active,
          );
        } else {
          print('Null data received for the cab with ID: $cabID');
          throw Exception('Null data received for the cab');
        }
      } else {
        print('Invalid data type received for the cab with ID: $cabID');
        throw Exception('Invalid data type received for the cab');
      }
    } else {
      throw Exception('Failed to load user with ID: $cabID');
    }
  }
}
