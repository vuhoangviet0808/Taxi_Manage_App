// viewmodels.dart

import 'package:flutter/material.dart';
import 'package:flutter_app/admin/services/services.dart';
import 'package:flutter_app/admin/models/models.dart';
import 'package:flutter_app/admin/models/cab_ride_model.dart';
import 'package:flutter_app/admin/views/views.dart';
import 'package:flutter_app/admin/services/cab_ride_services.dart';

class AdminDashboardViewModel {
  final AdminDashboardService service = AdminDashboardService();
  final CabRideService cabRideService;

  AdminDashboardViewModel(this.cabRideService);

  Future<List<Driver>> fetchDrivers() async {
    return await service.fetchDrivers();
  }

  void fetchEachDriver(BuildContext context, String driverID) {
    service.fetchEachDriver(driverID).then((driver) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DriverDetailScreen(driver: driver),
        ),
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content:
                Text('Không thể tải thông tin tài xế. Vui lòng thử lại sau.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Đóng'),
              ),
            ],
          );
        },
      );
    });
  }

  Future<List<Cab_ride>> fetchCabRides() async {
    return cabRideService.fetchCabRide();
  }
}
