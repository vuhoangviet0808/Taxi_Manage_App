// ignore_for_file: library_private_types_in_public_api, prefer_const_declarations, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_app/admin/viewmodels/viewmodels.dart';
import 'package:flutter_app/admin/models/models.dart';

class DriverReportScreenView extends StatefulWidget {
  final List<Driver> drivers;
  final AdminDashboardViewModel viewModel;

  const DriverReportScreenView({
    Key? key,
    required this.drivers,
    required this.viewModel,
  }) : super(key: key);

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
        title:
            Text('Driver Information', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        color: Color.fromARGB(255, 203, 235, 231), // Thêm màu nền ở đây
        child: Column(
          children: [
            _buildSearchSection(),
            _buildDriverCount(filteredDrivers.length),
            Expanded(
              child: Container(
                color: Colors.white, // Màu nền trắng cho bảng thông tin
                child: _buildDriverTable(filteredDrivers),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text("Filter"),
        leading: Icon(Icons.search, color: Colors.teal),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSoftSearchField(
              label: 'By ID',
              onChanged: (value) {
                setState(() {
                  idFilter = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSoftSearchField(
              label: 'By Name',
              onChanged: (value) {
                setState(() {
                  nameFilter = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoftSearchField(
      {required String label, required Function(String) onChanged}) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.search, color: Colors.teal),
        filled: true,
        fillColor: Colors.teal.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.teal),
        ),
      ),
    );
  }

  Widget _buildDriverCount(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Quantity: $count',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildDriverTable(List<Driver> drivers) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 60.0,
            headingRowHeight: 56.0,
            dataRowHeight: 56.0,
            headingRowColor: MaterialStateColor.resolveWith(
                (states) => Colors.teal.shade100),
            columns: [
              DataColumn(
                label: Text(
                  'ID',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              DataColumn(
                label: Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              DataColumn(
                label: Text(
                  'Avatar',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
            rows: drivers.map((driver) {
              return DataRow(cells: [
                DataCell(
                  GestureDetector(
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
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    "${driver.Firstname} ${driver.Lastname}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/admin/adminDefault.jpg'),
                        radius: 20,
                      ),
                    ],
                  ),
                ),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class DriverDetailScreen extends StatelessWidget {
  final FullDriver driver;

  const DriverDetailScreen({Key? key, required this.driver}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double fontSize = 16.0;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 203, 235, 231),
      appBar: AppBar(
        title:
            Text('Detailed Information', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: Colors.black, width: 1), // Viền đen
                    ),
                    child: CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/admin/adminDefault.jpg'),
                      radius: 60,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${driver.Firstname} ${driver.Lastname}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Bọc các trường thông tin từ ID trở xuống vào Container
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Màu nền cho Container
                borderRadius: BorderRadius.circular(10), // Bo góc
              ),
              padding: EdgeInsets.only(
                  bottom: 10,
                  top: 20,
                  left: 30,
                  right: 30), // Thêm padding cho Container
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('ID: ', driver.Driver_ID, fontSize),
                  SizedBox(height: 7),
                  _buildDetailRow('Phone number: ', driver.SDT, fontSize),
                  SizedBox(height: 7),
                  _buildDetailRow('Wallet: ', driver.Wallet, fontSize),
                  SizedBox(height: 7),
                  _buildDetailRow('DOB: ', driver.DOB, fontSize),
                  SizedBox(height: 7),
                  _buildDetailRow('Gender: ', driver.Gender, fontSize),
                  SizedBox(height: 7),
                  _buildDetailRow('Address: ', driver.Address, fontSize),
                  SizedBox(height: 7),
                  _buildDetailRow('Identity Card: ', driver.CCCD, fontSize),
                  SizedBox(height: 7),
                  _buildDetailRow('Driver license: ',
                      driver.Driving_licence_number, fontSize),
                  SizedBox(height: 7),
                  _buildDetailRow('Working experience in years: ',
                      driver.Working_experiment, fontSize),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, double fontSize) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: fontSize,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                color: Colors.black,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
