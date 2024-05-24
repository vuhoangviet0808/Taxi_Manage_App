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
            //Thieu kinh nghiem
          ],
        ),
      ),
    );
  }
}
