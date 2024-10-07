import 'package:flutter/material.dart';
import 'package:flutter_app/admin/models/driver_by_revenue_model.dart';
import 'package:flutter_app/admin/models/models.dart';
import 'package:flutter_app/admin/viewmodels/viewmodels.dart';
import 'package:flutter_app/admin/views/driver_revenue_detail_view.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DriverRevenueReportScreenView extends StatefulWidget {
  final List<Driver> drivers;
  final AdminDashboardViewModel viewModel;

  const DriverRevenueReportScreenView({
    Key? key,
    required this.drivers,
    required this.viewModel,
  }) : super(key: key);

  @override
  _DriverRevenueReportScreenViewState createState() =>
      _DriverRevenueReportScreenViewState();
}

class _DriverRevenueReportScreenViewState
    extends State<DriverRevenueReportScreenView> {
  String nameFilter = '';
  String idFilter = '';
  DateTime? startDate;
  DateTime? endDate;
  List<Driver> sortedDrivers = [];
  bool isLoading = false;

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
        title: Text('Driver Revenue', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          _buildSearchSection(),
      _buildDriverCount(
          (sortedDrivers.isNotEmpty ? sortedDrivers : filteredDrivers)
              .length),
          if (isLoading) Center(child: CircularProgressIndicator()),
          _buildDriverTable(
              sortedDrivers.isNotEmpty ? sortedDrivers : filteredDrivers),
        ],
      ),
      body: Container(
        color: Color.fromARGB(255, 203, 235, 231), // Thêm màu nền ở đây
        child: Column(
          children: [
            _buildSearchSection(),
            _buildDriverCount(
                (sortedDrivers.isNotEmpty ? sortedDrivers : filteredDrivers)
                    .length),
            Expanded(
              child: Container(
                  color: Colors.white, // Màu nền trắng cho bảng thông tin
                  child: _buildDriverTable(sortedDrivers.isNotEmpty
                      ? sortedDrivers
                      : filteredDrivers)),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                final pickedDate = await _selectDate(context, startDate);
                if (pickedDate != null) {
                  setState(() {
                    startDate = pickedDate;
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: startDate != null
                        ? DateFormat('dd-MM-yyyy').format(startDate!)
                        : 'Start Date',
                    prefixIcon: Icon(Icons.calendar_today, color: Colors.teal),
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
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                final pickedDate = await _selectDate(context, endDate);
                if (pickedDate != null) {
                  setState(() {
                    endDate = pickedDate;
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: endDate != null
                        ? DateFormat('dd-MM-yyyy').format(endDate!)
                        : 'End Date',
                    prefixIcon: Icon(Icons.calendar_today, color: Colors.teal),
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
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // Căn giữa hai nút
            children: [
              ElevatedButton(
                onPressed: () {
                  if (startDate != null && endDate != null) {
                    _fetchDriversRevenue();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter Start Date and End Date'),
                      ),
                    );
                  }
                },
                child: Text('Highest to Lowest Revenue',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    nameFilter = '';
                    idFilter = '';
                    startDate = null;
                    endDate = null;
                    sortedDrivers = [];
                  });
                },
                child: Text('Reset', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
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
          padding: const EdgeInsets.all(8.0),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DriverRevenueDetailScreen(
                              driverId: driver.Driver_ID),
                        ),
                      );
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

  Future<DateTime?> _selectDate(
      BuildContext context, DateTime? initialDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    return pickedDate;
  }

  Future<void> _fetchDriversRevenue() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:5000/admin/driver_by_revenue?start_date=${DateFormat('dd-MM-yyyy').format(startDate!)}&end_date=${DateFormat('dd-MM-yyyy').format(endDate!)}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> revenueData =
            json.decode(response.body)['driver_revenue_data'];

        final List<DriverRevenue> driverRevenues =
            revenueData.map((json) => DriverRevenue.fromJson(json)).toList();

        driverRevenues.sort((a, b) => b.totalRevenue.compareTo(a.totalRevenue));

        sortedDrivers = driverRevenues
            .map((driverRevenue) => driverRevenue.toDriver())
            .toList();

        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xảy ra lỗi khi tải dữ liệu.'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi khi tải dữ liệu: $e'),
        ),
      );
    }
  }
}
