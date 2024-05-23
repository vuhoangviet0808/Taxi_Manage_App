// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

/*
import 'package:flutter/material.dart';
import 'package:flutter_app/admin/viewmodels/viewmodels.dart';
import 'package:flutter_app/admin/models/models.dart';


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
                onTap: () {},
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

class DriverReportScreenView extends StatefulWidget {
  final List<Driver> drivers;
  final AdminDashboardViewModel viewModel;

  const DriverReportScreenView(
      {Key? key, required this.drivers, required this.viewModel})
      : super(key: key);

  @override
  _DriverReportScreenViewState createState() => _DriverReportScreenViewState();
}

class _DriverReportScreenViewState extends State<DriverReportScreenView> {
  String nameFilter = '';
  String idFilter = '';

  @override
  Widget build(BuildContext context) {
    List<Driver> filteredDrivers = widget.drivers.where((driver) {
      return (driver.Firstname.toLowerCase()
                  .contains(nameFilter.toLowerCase()) ||
              driver.Lastname.toLowerCase()
                  .contains(nameFilter.toLowerCase())) &&
          driver.Driver_ID.contains(idFilter);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin tài xế'),
      ),
      body: Column(
        children: [
          ExpansionTile(
            title: Text("Tìm kiếm"),
            leading: Icon(Icons.search),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      nameFilter = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Tìm kiếm theo tên',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      idFilter = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Tìm kiếm theo ID',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: MediaQuery.of(context).size.width - 200,
                  columns: [
                    DataColumn(
                      label: Text(
                        'Họ tên',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'ID',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ],
                  rows: filteredDrivers.map((driver) {
                    return DataRow(cells: [
                      DataCell(
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "${driver.Firstname} ${driver.Lastname}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () {
                              widget.viewModel
                                  .fetchEachDriver(context, driver.Driver_ID);
                            },
                            child: Text(
                              driver.Driver_ID,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DriverDetailScreen extends StatelessWidget {
  final FullDriver driver;

  const DriverDetailScreen({Key? key, required this.driver}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin chi tiết tài xế'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
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
            //         Text('Kinh nghiệm làm việc: ${driver.Working_experiment}'),
            //SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_app/admin/viewmodels/viewmodels.dart';
import 'package:flutter_app/admin/models/models.dart';
import 'package:flutter_app/admin/models/cab_ride_model.dart';

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CabRideListScreen(
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

class DriverReportScreenView extends StatefulWidget {
  final List<Driver> drivers;
  final AdminDashboardViewModel viewModel;

  const DriverReportScreenView(
      {Key? key, required this.drivers, required this.viewModel})
      : super(key: key);

  @override
  _DriverReportScreenViewState createState() => _DriverReportScreenViewState();
}

class _DriverReportScreenViewState extends State<DriverReportScreenView> {
  String nameFilter = '';
  String idFilter = '';

  @override
  Widget build(BuildContext context) {
    List<Driver> filteredDrivers = widget.drivers.where((driver) {
      return (driver.Firstname.toLowerCase()
                  .contains(nameFilter.toLowerCase()) ||
              driver.Lastname.toLowerCase()
                  .contains(nameFilter.toLowerCase())) &&
          driver.Driver_ID.contains(idFilter);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin tài xế'),
      ),
      body: Column(
        children: [
          ExpansionTile(
            title: Text("Tìm kiếm"),
            leading: Icon(Icons.search),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      nameFilter = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Tìm kiếm theo tên',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      idFilter = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Tìm kiếm theo ID',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: MediaQuery.of(context).size.width - 200,
                  columns: [
                    DataColumn(
                      label: Text(
                        'Họ tên',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'ID',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ],
                  rows: filteredDrivers.map((driver) {
                    return DataRow(cells: [
                      DataCell(
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "${driver.Firstname} ${driver.Lastname}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () {
                              widget.viewModel
                                  .fetchEachDriver(context, driver.Driver_ID);
                            },
                            child: Text(
                              driver.Driver_ID,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DriverDetailScreen extends StatelessWidget {
  final FullDriver driver;

  const DriverDetailScreen({Key? key, required this.driver}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin chi tiết tài xế'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
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
          ],
        ),
      ),
    );
  }
}

class CabRideListScreen extends StatelessWidget {
  final AdminDashboardViewModel viewModel;

  const CabRideListScreen({Key? key, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lí chuyến đi'),
      ),
      body: FutureBuilder<List<Cab_ride>>(
        future: viewModel.fetchCabRides(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load cab rides'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No cab rides available'));
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Start Time')),
                ],
                rows: snapshot.data!
                    .map((cabRide) => DataRow(cells: [
                          DataCell(Text(cabRide.ID.toString())),
                          DataCell(Text(cabRide.ride_start_time)),
                        ]))
                    .toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
