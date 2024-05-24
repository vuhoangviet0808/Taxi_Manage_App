import 'package:flutter/material.dart';
import 'package:flutter_app/admin/viewmodels/viewmodels.dart';
import 'package:flutter_app/admin/models/models.dart';
import 'package:flutter_app/admin/models/cab_ride_model.dart';
import 'package:flutter_app/admin/views/driver_report_view.dart';
import 'package:flutter_app/admin/views/cab_ride_list_screen_view.dart';

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
                onTap: () async {
                  List<Driver> drivers = await viewModel.fetchDrivers();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DriverReportScreenView(
                        drivers: drivers,
                        viewModel: viewModel,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.star),
                title: Text('Quản lí chuyến đi'),
                onTap: () async {
                  List<Cab_ride> cabRides = await viewModel.fetchCabRides();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CabRideListScreen(
                        cabRides: cabRides,
                        viewModel: viewModel,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.star),
                title: Text('Báo cáo và thống kê'),
                onTap: () {
                  //Navigator.pushNamed(context, '/report');
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
