import 'package:flutter/material.dart';

import 'package:flutter_app/admin/viewmodels/viewmodels.dart';
import 'package:flutter_app/admin/viewmodels/cab_ride_viewmodels.dart';
import 'package:flutter_app/admin/viewmodels/user_viewmodels.dart';
import 'package:flutter_app/admin/viewmodels/shift_viewmodels.dart';
import 'package:flutter_app/admin/viewmodels/cab_viewmodels.dart';

import 'package:flutter_app/admin/models/models.dart';
import 'package:flutter_app/admin/models/cab_ride_model.dart';
import 'package:flutter_app/admin/models/user_model.dart';
import 'package:flutter_app/admin/models/shift_model.dart';
import 'package:flutter_app/admin/models/cab_model.dart';

import 'package:flutter_app/admin/views/driver_report_view.dart';
import 'package:flutter_app/admin/views/cab_ride_list_screen_view.dart';
import 'package:flutter_app/admin/views/driver_revenue_report_view.dart';

import 'package:flutter_app/admin/views/noti_view.dart';

import 'package:flutter_app/admin/views/user_report_view.dart';
import 'package:flutter_app/admin/views/shift_report_view.dart';
import 'package:flutter_app/admin/views/cab_report_view.dart';
import 'package:flutter_app/admin/views/company_revenue_detail_view.dart';

import 'package:flutter_app/common/views/login_page.dart';

class AdminDashboardView extends StatelessWidget {
  final AdminDashboardViewModel viewModel;
  final CabRideDashboardViewModel CabRideViewModel;
  final UserDashboardViewModel UserViewModel;
  //final ShiftDashboardViewModel ShiftViewModel;
  final CabDashboardViewModel CabViewModel;

  AdminDashboardView({
    Key? key,
    required this.viewModel,
    required this.CabRideViewModel,
    required this.UserViewModel,
    //required this.ShiftViewModel,
    required this.CabViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bảng điều khiển quản trị',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildManagementSection(context),
              _buildRevenueSection(context),
              _buildNotificationSection(context),
              _buildProfileSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManagementSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        leading: Icon(Icons.supervisor_account, color: Colors.teal),
        title: Text('Quản lí', style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          _buildListTile(
            context,
            icon: Icons.star,
            title: 'Quản lí tài xế',
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
          _buildListTile(
            context,
            icon: Icons.star,
            title: 'Quản lí chuyến đi',
            onTap: () async {
              List<Cab_ride> cabRides = await CabRideViewModel.fetchCabRides();
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
          _buildListTile(
            context,
            icon: Icons.star,
            title: 'Quản lí người dùng',
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
          /*
          _buildListTile(
            context,
            icon: Icons.star,
            title: 'Quản lí ca làm việc',
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
          */
          _buildListTile(
            context,
            icon: Icons.star,
            title: 'Quản lí xe',
            onTap: () async {
              List<Cab> cabs = await CabViewModel.fetchCabs();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CabReportScreenView(
                    cabs: cabs,
                    viewModel: CabViewModel,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        leading: Icon(Icons.business_center, color: Colors.teal),
        title: Text('Doanh Thu', style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          _buildListTile(
            context,
            icon: Icons.monetization_on,
            title: 'Doanh thu tài xế',
            onTap: () async {
              List<Driver> drivers = await viewModel.fetchDrivers();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DriverRevenueReportScreenView(
                    drivers: drivers,
                    viewModel: viewModel,
                  ),
                ),
              );
            },
          ),
          _buildListTile(
            context,
            icon: Icons.monetization_on,
            title: 'Doanh thu công ty',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompanyRevenueDetailScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        leading: Icon(Icons.notifications, color: Colors.teal),
        title: Text('Thông báo', style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          _buildListTile(
            context,
            icon: Icons.local_taxi,
            title: 'Thông báo đặt xe mới',
            onTap: () {
              // Chuyển đến màn hình thông báo đặt xe mới
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NewBookingNotificationScreen(), // Thay bằng màn hình hiển thị thông báo của bạn
                ),
              );
            },
          ),
          _buildListTile(
            context,
            icon: Icons.update,
            title: 'Cập nhật trạng thái chuyến đi',
            onTap: () {
              // Chuyển đến màn hình cập nhật trạng thái chuyến đi
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TripStatusUpdateScreen(), // Thay bằng màn hình hiển thị thông báo của bạn
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.logout, color: Colors.teal),
          title:
              Text('Đăng xuất', style: TextStyle(fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required String title,
      required Function onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title),
      onTap: () => onTap(),
    );
  }
}
