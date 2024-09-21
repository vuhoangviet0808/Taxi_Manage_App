import 'package:flutter/material.dart';
import 'package:flutter_app/admin/models/shift_model.dart';
import 'package:flutter_app/admin/services/shift_services.dart';
import 'package:flutter_app/admin/views/shift_report_view.dart';

class ShiftDashboardViewModel {
  final ShiftService service = ShiftService();

  Future<List<Shift>> fetchShift() async {
    return service.fetchShift();
  }

  void fetchEachShift(BuildContext context, String ID) {
    service.fetchEachShift(ID).then((shift) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShiftDetailScreen(shift: shift),
        ),
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text(
                'Không thể tải thông tin ca làm việc. Vui lòng thử lại sau.'),
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
