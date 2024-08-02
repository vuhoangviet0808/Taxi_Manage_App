// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_app/admin/viewmodels/viewmodels.dart';
import 'package:flutter_app/admin/viewmodels/cab_ride_viewmodels.dart';
import 'package:flutter_app/admin/viewmodels/user_viewmodels.dart';
import 'package:flutter_app/admin/viewmodels/shift_viewmodels.dart';

import 'package:flutter_app/admin/models/models.dart';
import 'package:flutter_app/admin/models/cab_ride_model.dart';
import 'package:flutter_app/admin/models/user_model.dart';
import 'package:flutter_app/admin/models/shift_model.dart';

import 'package:flutter_app/admin/views/driver_report_view.dart';
import 'package:flutter_app/admin/views/cab_ride_list_screen_view.dart';
import 'package:flutter_app/admin/views/user_report_view.dart';
import 'package:flutter_app/admin/views/shift_report_view.dart';

class AdminDashboardView extends StatelessWidget {
  final AdminDashboardViewModel viewModel;
  final CabRideDashboardViewModel CabRideViewModel;
  final UserDashboardViewModel UserViewModel;
  final ShiftDashboardViewModel ShiftViewModel;

  AdminDashboardView({
    Key? key,
    required this.viewModel,
    required this.CabRideViewModel,
    required this.UserViewModel,
    required this.ShiftViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Column(
        children: [
          ExpansionTile(
            leading: Icon(Icons.supervisor_account),
            title: Text('Quản lí'),
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
                  List<Cab_ride> cabRides =
                      await CabRideViewModel.fetchCabRides();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CabRideListScreen(
                        cabRides: cabRides,
                        viewModel: CabRideViewModel,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.star),
                title: Text('Quản lí người dùng'),
                onTap: () async {
                  List<User> users = await UserViewModel.fetchUsers();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserReportScreenView(
                        users: users,
                        viewModel: UserViewModel,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.star),
                title: Text('Quản lí ca làm việc'),
                onTap: () async {
                  List<Shift> shifts = await ShiftViewModel.fetchShift();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShiftReportScreenView(
                        shifts: shifts,
                        viewModel: ShiftViewModel,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.business_center),
            title: Text('Doanh Thu'),
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
