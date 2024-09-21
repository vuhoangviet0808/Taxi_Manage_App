// ignore_for_file: library_private_types_in_public_api, prefer_const_declarations, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_app/admin/viewmodels/shift_viewmodels.dart';
import 'package:flutter_app/admin/viewmodels/viewmodels.dart';
import 'package:flutter_app/admin/viewmodels/cab_viewmodels.dart';
import 'package:flutter_app/admin/models/shift_model.dart';

class ShiftReportScreenView extends StatefulWidget {
  final List<Shift> shifts;
  final ShiftDashboardViewModel viewModel;

  const ShiftReportScreenView({
    Key? key,
    required this.shifts,
    required this.viewModel,
  }) : super(key: key);

  @override
  _ShiftReportScreenViewState createState() => _ShiftReportScreenViewState();
}

class _ShiftReportScreenViewState extends State<ShiftReportScreenView> {
  String idFilter = '';
  String startTimeFilter = '';

  @override
  Widget build(BuildContext context) {
    List<Shift> filteredShifts = widget.shifts.where((shift) {
      return shift.ID.contains(idFilter) &&
          shift.shift_start_time
              .toLowerCase()
              .contains(startTimeFilter.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Báo cáo ca làm việc'),
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
                      startTimeFilter = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Tìm kiếm theo thời gian bắt đầu',
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
                  'Số lượng: ${filteredShifts.length}',
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
                  columns: [
                    DataColumn(
                      label: Text(
                        'ID',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Thời gian bắt đầu',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                  rows: filteredShifts.map((shift) {
                    return DataRow(cells: [
                      DataCell(
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () {
                              widget.viewModel
                                  .fetchEachShift(context, shift.ID);
                            },
                            child: Text(
                              shift.ID,
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
                          alignment: Alignment.centerLeft, // Căn lề trái
                          padding: EdgeInsets.all(8),
                          child: Text(
                            shift.shift_start_time,
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

class ShiftDetailScreen extends StatelessWidget {
  final FullShift shift;
  final AdminDashboardViewModel driverViewModel = AdminDashboardViewModel();
  final CabDashboardViewModel cabViewModel = CabDashboardViewModel();
  ShiftDetailScreen({Key? key, required this.shift}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double fontSize = 16.0;
    final double increasedFontSize = fontSize * 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin chi tiết ca làm việc'),
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
                    text: 'ID ca làm việc: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: '${shift.ID}',
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
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        driverViewModel.fetchEachDriver(
                            context, shift.Driver_id);
                      },
                      child: Text(
                        '${shift.Driver_id}',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: increasedFontSize,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Add more fields as needed
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'ID xe: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        cabViewModel.fetchEachCab(context, shift.cab_id);
                      },
                      child: Text(
                        '${shift.cab_id}',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: increasedFontSize,
                          decoration: TextDecoration.underline,
                        ),
                      ),
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
                    text: 'Thời gian ca làm việc bắt đầu: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: '${shift.shift_start_time}',
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
                    text: 'Thời gian ca làm việc kết thúc: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: '${shift.shift_end_time}',
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
                    text: 'Thời gian đăng nhập ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: '${shift.login_time}',
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
                    text: 'Thời gian đăng xuất ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: '${shift.logout_time}',
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
