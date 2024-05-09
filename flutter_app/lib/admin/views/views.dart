import 'package:flutter/material.dart';
import 'package:flutter_app/admin/viewmodels/viewmodels.dart';

class AdminDashboardView extends StatelessWidget {
  final AdminDashboardViewModel viewModel;

  const AdminDashboardView({Key? key, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Column(
        children: [
          ExpansionTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Stats'),
            children: [
              ListTile(
                leading: Icon(Icons.star),
                title: Text('Quản lí tài xế'),
                onTap: () {
                  viewModel.fetchDrivers(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.star),
                title: Text('Quản lí đơn hàng'),
                onTap: () {
                  //viewModel.fetchOrders(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.star),
                title: Text('Báo cáo và thống kê'),
                onTap: () {
                  Navigator.pushNamed(context, '/report');
                },
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Edit Profile'),
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Password'),
          ),
          ListTile(
            leading: Icon(Icons.power_settings_new),
            title: Text('Logout'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}

class ReportScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Báo cáo và thống kê'),
      ),
      body: Center(
        child: Text('Đây là trang báo cáo và thống kê'),
      ),
    );
  }
}
