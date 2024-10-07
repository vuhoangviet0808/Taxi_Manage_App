// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/admin/models/models.dart';

class AdminDashboardService {
  Future<List<Driver>> fetchDrivers() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5000/admin/drivers'));
    if (response.statusCode == 200) {
      List<dynamic> driversData = json.decode(response.body);
      List<Driver> driver_info = [];
      for (var driverData in driversData) {
        if (driverData['Firstname'] != null &&
            driverData["Lastname"] != null &&
            driverData['Driver_ID'] != null) {
          String driverID = driverData['Driver_ID'].toString();
          driver_info.add(Driver(
              driverData['Firstname'], driverData['Lastname'], driverID));
        } else {
          print('Null data received for a driver.');
        }
      }
      return driver_info;
    } else {
      throw Exception('Failed to load drivers');
    }
  }

  Future<FullDriver> fetchEachDriver(String driverID) async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:5000/admin/drivers/$driverID'));

    if (response.statusCode == 200) {
      dynamic responseBody = json.decode(response.body);

      if (responseBody is List) {
        if (responseBody.isNotEmpty) {
          responseBody = responseBody.first;
        } else {
          print('Empty list received for the driver with ID: $driverID');
          throw Exception('Empty list received for the driver');
        }
      }

      if (responseBody is Map<String, dynamic>) {
        if (responseBody['Driver_ID'] != null) {
          String driverID = responseBody['Driver_ID'].toString();
          String driverWallet = responseBody['Wallet'].toString();
          String driverExperiment =
              responseBody['Working_experiment'].toString();

          return FullDriver(
            responseBody['Firstname'],
            responseBody['Lastname'],
            driverID,
            responseBody['SDT'],
            driverWallet,
            responseBody['DOB'],
            responseBody['Gender'],
            responseBody['Address'],
            responseBody['CCCD'],
            responseBody['Driving_licence_number'],
            driverExperiment,
          );
        } else {
          print('Null data received for the driver with ID: $driverID');
          throw Exception('Null data received for the driver');
        }
      } else {
        print('Invalid data type received for the driver with ID: $driverID');
        throw Exception('Invalid data type received for the driver');
      }
    } else {
      throw Exception('Failed to load driver with ID: $driverID');
    }
  }
}
