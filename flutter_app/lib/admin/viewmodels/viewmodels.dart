// ignore_for_file: unnecessary_null_comparison, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_app/admin/services/services.dart';


class AdminDashboardViewModel {
  final AdminDashboardService service = AdminDashboardService();

  void fetchDrivers(BuildContext context) {
    service.fetchDrivers().then((drivers) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông tin tài xế'),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: drivers.length,
                itemBuilder: (BuildContext context, int index) {
                  final driver = drivers[index];
                  if (driver != null &&
                      driver.name != null &&
                      driver.dob != null) {
                    return ListTile(
                      title: Text(driver.name),
                      subtitle: Text(driver.dob),
                    );
                  } else {
                    return Container();
                  }
                },
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

  void fetchOrders(BuildContext context) {
    service.fetchOrders().then((orders) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông tin đơn hàng'),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: orders.length,
                itemBuilder: (BuildContext context, int index) {
                  final order = orders[index];
                  if (order != null &&
                      order.time != null &&
                      order.date != null) {
                    return ListTile(
                      title: Text(order.time),
                      subtitle: Text(order.date),
                    );
                  } else {
                    return Container();
                  }
                },
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
}
