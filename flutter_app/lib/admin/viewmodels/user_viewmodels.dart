import 'package:flutter/material.dart';
import 'package:flutter_app/admin/services/User_services.dart';
import 'package:flutter_app/admin/models/user_model.dart';
import 'package:flutter_app/admin/views/user_report_view.dart';

class UserDashboardViewModel {
  final UserService service = UserService();

  Future<List<User>> fetchUsers() async {
    return await service.fetchUsers();
  }

  void fetchEachUser(BuildContext context, String userID) {
    service.fetchEachUser(userID).then((user) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserDetailScreen(user: user),
        ),
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text(
                'Không thể tải thông tin người dùng. Vui lòng thử lại sau.'),
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
