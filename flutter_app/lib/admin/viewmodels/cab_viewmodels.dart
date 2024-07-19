import 'package:flutter/material.dart';
import 'package:flutter_app/admin/models/cab_model.dart';
import 'package:flutter_app/admin/services/cab_services.dart';
import 'package:flutter_app/admin/views/cab_report_view.dart';

class CabDashboardViewModel {
  final CabService service = CabService();

  Future<List<Cab>> fetchCabs() async {
    return service.fetchCabs();
  }

  void fetchEachCab(BuildContext context, String cabID) {
    service.fetchEachCab(cabID).then((cab) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CabDetailScreen(cab: cab),
        ),
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content:
                Text('Không thể tải thông tin xe taxi. Vui lòng thử lại sau.'),
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
