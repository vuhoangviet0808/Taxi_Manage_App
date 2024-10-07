//
import 'package:flutter/material.dart';
import 'package:flutter_app/admin/viewmodels/viewmodels.dart';
import 'package:flutter_app/admin/viewmodels/cab_ride_viewmodels.dart';
import 'package:flutter_app/admin/viewmodels/user_viewmodels.dart';
import 'package:flutter_app/admin/viewmodels/cab_viewmodels.dart';
import 'package:flutter_app/admin/models/models.dart';
import 'package:flutter_app/admin/models/cab_ride_model.dart';
import 'package:flutter_app/admin/models/user_model.dart';
import 'package:flutter_app/admin/models/cab_model.dart';
import 'package:flutter_app/admin/views/carType_view.dart';
import 'package:flutter_app/admin/views/driver_report_view.dart';
import 'package:flutter_app/admin/views/cab_ride_list_screen_view.dart';
import 'package:flutter_app/admin/views/driver_revenue_report_view.dart';
import 'package:flutter_app/admin/views/noti_view.dart';
import 'package:flutter_app/admin/views/user_report_view.dart';
import 'package:flutter_app/admin/views/cab_report_view.dart';
import 'package:flutter_app/admin/views/company_revenue_detail_view.dart';
import 'package:flutter_app/common/views/login_page.dart';

class AdminDashboardView extends StatelessWidget {
  final AdminDashboardViewModel viewModel;
  final CabRideDashboardViewModel CabRideViewModel;
  final UserDashboardViewModel UserViewModel;
  final CabDashboardViewModel CabViewModel;

  AdminDashboardView({
    Key? key,
    required this.viewModel,
    required this.CabRideViewModel,
    required this.UserViewModel,
    required this.CabViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Admin Panel', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.teal,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                color: Colors.white,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          )),
      drawer: FractionallySizedBox(
        widthFactor: 0.5, // Chiếm 50% chiều rộng màn hình
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Admin Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 10),
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          AssetImage('assets/admin/adminImage.jpg'),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('My Profile'),
                onTap: () {
                  // Tạm thời chưa có logic gì ở đây
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
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
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              color: Color.fromARGB(255, 203, 235, 231),
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(height: 12.0),
                  _buildManagementSection(context),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: _buildRevenueSection(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: _buildNotificationSection(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: _buildEvaluationSection(context),
                  ),
                ],
              ),
            ),
            Container(
              color: Color.fromARGB(255, 203, 235, 231),
              padding: EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 217, 219, 219),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 197, 200, 200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .start, // Căn trái cho cả 2 phần tử
                          children: [
                            Text(
                              'Monthly Statistic',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                                width: 130), // Khoảng cách giữa text và icon
                            Icon(
                              Icons.assessment, // Bạn có thể chọn icon bạn muốn
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              //color: Color.fromARGB(255, 239, 236, 236),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Successful Rides',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(
                                          255, 62, 175, 65)),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '3',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(
                                          255, 62, 175, 65)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10), // Khoảng cách giữa 2 ô
                        Expanded(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              //color: Color.fromARGB(255, 53, 52, 52),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Cancelled Rides',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '4', // Giả sử đây là số chuyến hủy, bạn có thể thay bằng dữ liệu thực tế
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.blue,
      child: ExpansionTile(
        leading: Icon(Icons.supervisor_account, color: Colors.white),
        title: Text(
          'Management',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        children: [
          _buildListTile(
            context,
            icon: Icons.star,
            title: 'Driver Management',
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
            title: 'Cab Ride Management',
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
            title: 'User Management',
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
          _buildListTile(
            context,
            icon: Icons.star,
            title: 'Cab Management',
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
      color: const Color.fromARGB(255, 70, 236, 76),
      child: ExpansionTile(
        leading: Icon(Icons.business_center, color: Colors.white),
        title: Text('Revenue',
            style: TextStyle(fontSize: 20, color: Colors.white)),
        children: [
          _buildListTile(
            context,
            icon: Icons.monetization_on,
            title: 'Driver Revenue',
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
            title: 'Company Revenue',
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
      color: Colors.red,
      child: ExpansionTile(
        leading: Icon(Icons.notifications, color: Colors.white),
        title: Text('Notification',
            style: TextStyle(fontSize: 20, color: Colors.white)),
        children: [
          FutureBuilder<int>(
            future: viewModel
                .fetchTotalBookingRequests(), // Gọi hàm lấy số lượng booking requests
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Hiển thị loader khi đang fetch data
                return ListTile(
                  leading: Icon(Icons.local_taxi, color: Colors.white),
                  title: Text('New Booking Requests',
                      style: TextStyle(color: Colors.white)),
                  trailing: CircularProgressIndicator(),
                  onTap: () {},
                );
              } else if (snapshot.hasError) {
                // Nếu xảy ra lỗi, hiển thị thông báo lỗi
                return ListTile(
                  leading: Icon(Icons.local_taxi, color: Colors.white),
                  title: Text('New Booking Requests',
                      style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.error, color: Colors.red),
                  onTap: () {},
                );
              } else {
                // Hiển thị số lượng booking requests khi fetch thành công
                return ListTile(
                  leading: Icon(Icons.local_taxi, color: Colors.white),
                  title: Text('New Booking Requests',
                      style: TextStyle(color: Colors.white)),
                  trailing: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white,
                    child: Text(
                      snapshot.data
                          .toString(), // Hiển thị số lượng booking requests
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewBookingNotificationScreen(),
                      ),
                    );
                  },
                );
              }
            },
          ),
          FutureBuilder<int>(
            future: viewModel
                .fetchTotalEarliestAssignedBookings(), // Gọi hàm lấy số lượng booking status updates
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Hiển thị loader khi đang fetch data
                return ListTile(
                  leading: Icon(Icons.update, color: Colors.teal),
                  title: Text('Requests Accepted',
                      style: TextStyle(color: Colors.white)),
                  trailing: CircularProgressIndicator(),
                  onTap: () {},
                );
              } else if (snapshot.hasError) {
                // Nếu xảy ra lỗi, hiển thị thông báo lỗi
                return ListTile(
                  leading: Icon(Icons.update, color: Colors.white),
                  title: Text('Requests Accepted'),
                  trailing: Icon(Icons.error, color: Colors.red),
                  onTap: () {},
                );
              } else {
                // Hiển thị số lượng booking status updates khi fetch thành công
                return ListTile(
                  leading: Icon(Icons.update, color: Colors.white),
                  title: Text('Requests Accepted',
                      style: TextStyle(color: Colors.white)),
                  trailing: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white,
                    child: Text(
                      snapshot.data
                          .toString(), // Hiển thị số lượng booking status updates
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TripStatusUpdateScreen(),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluationSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Color.fromARGB(255, 240, 217, 9),
      child: ExpansionTile(
        leading: Icon(Icons.assessment, color: Colors.white),
        title: Text('Evaluation',
            style: TextStyle(fontSize: 20, color: Colors.white)),
        children: [
          // Thêm nội dung nếu cần
          _buildListTile(
            context,
            icon: Icons.star,
            title: 'Booking Trends',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarTypePieChartView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required String title,
      required Function onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      onTap: () => onTap(),
    );
  }
}
