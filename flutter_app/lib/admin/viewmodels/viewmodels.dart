import 'package:flutter/material.dart';
import 'package:flutter_app/admin/services/Driver_services.dart';
import 'package:flutter_app/admin/models/models.dart';
import 'package:flutter_app/admin/views/driver_report_view.dart';

class AdminDashboardViewModel {
  final AdminDashboardService service = AdminDashboardService();

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

  void logout() {}
}
