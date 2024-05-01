import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/admin/models/models.dart';

class AdminDashboardService {
  Future<List<Driver>> fetchDrivers() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/drivers'));
    if (response.statusCode == 200) {
      List<dynamic> driversData = json.decode(response.body);
      List<Driver> drivers = [];
      for (var driverData in driversData) {
        drivers.add(Driver(driverData['họ tên'], driverData['ngày sinh']));
      }
      return drivers;
    } else {
      throw Exception('Failed to load drivers');
    }
  }

  Future<List<Order>> fetchOrders() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/orders'));
    if (response.statusCode == 200) {
      List<dynamic> ordersData = json.decode(response.body);
      List<Order> orders = [];
      for (var orderData in ordersData) {
        orders.add(Order(orderData['thời gian'], orderData['ngày']));
      }
      return orders;
    } else {
      throw Exception('Failed to load orders');
    }
  }
}
