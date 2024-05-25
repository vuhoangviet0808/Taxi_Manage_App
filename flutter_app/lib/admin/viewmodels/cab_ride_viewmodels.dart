import 'package:flutter/material.dart';
import 'package:flutter_app/admin/models/cab_ride_model.dart';
import 'package:flutter_app/admin/services/cab_ride_services.dart';
import 'package:flutter_app/admin/views/cab_ride_list_screen_view.dart';

class CabRideDashboardViewModel {
  //final AdminDashboardService service = AdminDashboardService();
  final CabRideService service = CabRideService();

  Future<List<Cab_ride>> fetchCabRides() async {
    return service.fetchCabRide();
  }

  void fetchEachCabRide(BuildContext context, String cabRideID) {
    service.fetchEachCabRide(cabRideID).then((cabRide) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CabRideDetailScreen(cabRide: cabRide),
        ),
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text(
                'Không thể tải thông tin chuyến đi. Vui lòng thử lại sau.'),
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
}
