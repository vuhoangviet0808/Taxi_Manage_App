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
        title: Text('Thông tin ca làm việc',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          _buildSearchSection(),
          _buildShiftCount(filteredShifts.length),
          _buildShiftTable(filteredShifts),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text("Tìm kiếm"),
        leading: Icon(Icons.search, color: Colors.teal),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSearchField(
              label: 'Tìm kiếm theo ID',
              onChanged: (value) {
                setState(() {
                  idFilter = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSearchField(
              label: 'Tìm kiếm theo thời gian bắt đầu',
              onChanged: (value) {
                setState(() {
                  startTimeFilter = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(
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

  Widget _buildShiftCount(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Số lượng: $count',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildShiftTable(List<Shift> shifts) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 24.0,
            headingRowHeight: 56.0,
            dataRowHeight: 56.0,
            headingRowColor:
                MaterialStateColor.resolveWith((states) => Colors.teal.shade50),
            columns: [
              DataColumn(
                label: Text(
                  'ID',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              DataColumn(
                label: Text(
                  'Thời gian bắt đầu',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
            rows: shifts.map((shift) {
              return DataRow(cells: [
                DataCell(
                  GestureDetector(
                    onTap: () {
                      widget.viewModel.fetchEachShift(context, shift.ID);
                    },
                    child: Text(
                      shift.ID,
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
                    shift.shift_start_time,
                    style: TextStyle(fontSize: 16),
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

class ShiftDetailScreen extends StatelessWidget {
  final FullShift shift;
  final AdminDashboardViewModel driverViewModel = AdminDashboardViewModel();
  final CabDashboardViewModel cabViewModel = CabDashboardViewModel();

  ShiftDetailScreen({Key? key, required this.shift}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double fontSize = 16.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin chi tiết ca làm việc'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildDetailText('ID ca làm việc: ', shift.ID),
            SizedBox(height: 8),
            _buildDetailText('ID tài xế: ', shift.Driver_id, isLink: true,
                onTap: () {
              driverViewModel.fetchEachDriver(context, shift.Driver_id);
            }),
            SizedBox(height: 8),
            _buildDetailText('ID xe: ', shift.cab_id, isLink: true, onTap: () {
              cabViewModel.fetchEachCab(context, shift.cab_id);
            }),
            SizedBox(height: 8),
            _buildDetailText(
                'Thời gian ca làm việc bắt đầu: ', shift.shift_start_time),
            SizedBox(height: 8),
            _buildDetailText(
                'Thời gian ca làm việc kết thúc: ', shift.shift_end_time),
            SizedBox(height: 8),
            _buildDetailText('Thời gian đăng nhập: ', shift.login_time),
            SizedBox(height: 8),
            _buildDetailText('Thời gian đăng xuất: ', shift.logout_time),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailText(String label, String value,
      {bool isLink = false, Function()? onTap}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
          isLink
              ? WidgetSpan(
                  child: GestureDetector(
                    onTap: onTap,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16.0,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                )
              : TextSpan(
                  text: value,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
        ],
      ),
    );
  }
}
