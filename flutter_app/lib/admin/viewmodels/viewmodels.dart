// ignore_for_file: unnecessary_null_comparison, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_app/admin/services/services.dart';

class AdminDashboardViewModel {
  final AdminDashboardService service = AdminDashboardService();

  void fetchDrivers(BuildContext context) {
    service.fetchDrivers().then((driver_info) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông tin tài xế'),
            content: Container(
              width: double.maxFinite,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Text(
                        'Họ tên',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'ID',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: driver_info.map((driver) {
                    return DataRow(cells: [
                      DataCell(
                        Text(
                          "${driver.Firstname} ${driver.Lastname}",
                        ),
                      ),
                      DataCell(
                        GestureDetector(
                          onTap: () {
                            fetchEachDriver(context, driver.Driver_ID);
                            //Navigator.pushNamed(context, '/detail');
                          },
                          child: Text(
                            driver.Driver_ID,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
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

  void fetchEachDriver(BuildContext context, String driverID) {
    service.fetchEachDriver(driverID).then((driver) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông tin chi tiết'),
            content: Container(
              width: double.maxFinite,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20), // Add spacing at the top
                    Text(
                      'Họ và tên: ${driver.Firstname} ${driver.Lastname}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: 8),
                    Text('ID: ${driver.Driver_ID}'),
                    SizedBox(height: 8),
                    Text('Số điện thoại: ${driver.SDT}'),
                    SizedBox(height: 8),
                    Text('Ví: ${driver.Wallet}'),
                    SizedBox(height: 8),
                    Text('Ngày sinh: ${driver.DOB}'),
                    SizedBox(height: 8),
                    Text('Giới tính: ${driver.Gender}'),
                    SizedBox(height: 8),
                    Text('Địa chỉ: ${driver.Address}'),
                    SizedBox(height: 8),
                    Text('CCCD: ${driver.CCCD}'),
                    SizedBox(height: 8),
                    Text('Số bằng lái: ${driver.Driving_licence_number}'),
                    SizedBox(height: 8),
                    Text('Kinh nghiệm làm việc: ${driver.Working_experiment}'),
                    SizedBox(height: 8), // Add spacing at the bottom
                  ],
                ),
              ),
            ),
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
}
