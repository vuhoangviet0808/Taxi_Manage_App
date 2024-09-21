// ignore_for_file: library_private_types_in_public_api, prefer_const_declarations, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_app/admin/viewmodels/viewmodels.dart';
import 'package:flutter_app/admin/models/models.dart';

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
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Số lượng: ${filteredDrivers.length}',
                  style: TextStyle(fontSize: 18),
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
                        'ID',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Họ tên',
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
                      DataCell(
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(8), // Căn lề trái
                          child: Text(
                            "${driver.Firstname} ${driver.Lastname}",
                            style: TextStyle(fontSize: 16),
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
    final double fontSize = 16.0;

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
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Họ và tên: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: '${driver.Firstname} ${driver.Lastname}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'ID tài xế: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: '${driver.Driver_ID}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Số điện thoại: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: '${driver.SDT}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Ví: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: '${driver.Wallet}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Ngày sinh: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: '${driver.DOB}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Giới tính: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: '${driver.Gender}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Địa chỉ: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: '${driver.Address}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'CCCD: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: '${driver.CCCD}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Số bằng lái: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: '${driver.Driving_licence_number}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Kinh nghiệm làm việc: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: '${driver.Working_experiment}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
