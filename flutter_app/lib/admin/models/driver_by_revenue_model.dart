import 'package:flutter_app/admin/models/models.dart';

class DriverRevenue {
  final int driverId;
  final String firstName;
  final String lastName;
  final double totalRevenue;

  DriverRevenue({
    required this.driverId,
    required this.firstName,
    required this.lastName,
    required this.totalRevenue,
  });

  factory DriverRevenue.fromJson(Map<String, dynamic> json) {
    return DriverRevenue(
      driverId: json['driver_id'],
      firstName: json['firstname'],
      lastName: json['lastname'],
      totalRevenue: json['total_revenue'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver_id': driverId,
      'firstname': firstName,
      'lastname': lastName,
      'total_revenue': totalRevenue,
    };
  }

  Driver toDriver() {
    return Driver(
      this.firstName,
      this.lastName,
      this.driverId.toString(),
    );
  }
}

class DriverRevenueResponse {
  final List<DriverRevenue> drivers;

  DriverRevenueResponse({required this.drivers});

  factory DriverRevenueResponse.fromJson(Map<String, dynamic> json) {
    var list = json['drivers'] as List;
    List<DriverRevenue> driversList =
        list.map((i) => DriverRevenue.fromJson(i)).toList();

    return DriverRevenueResponse(drivers: driversList);
  }

  Map<String, dynamic> toJson() {
    return {
      'drivers': drivers.map((driver) => driver.toJson()).toList(),
    };
  }

  // Convert DriverRevenueResponse to List<Driver>
  List<Driver> toDriverList() {
    return drivers.map((driverRevenue) => driverRevenue.toDriver()).toList();
  }
}
