import 'package:flutter/material.dart';
import 'package:flutter_app/admin/viewmodels/cab_ride_viewmodels.dart';
import 'package:flutter_app/admin/models/cab_ride_model.dart';
import 'package:flutter_app/admin/viewmodels/shift_viewmodels.dart';
import 'package:flutter_app/admin/viewmodels/user_viewmodels.dart';

class CabRideListScreen extends StatefulWidget {
  final List<Cab_ride> cabRides;
  final CabRideDashboardViewModel viewModel;

  const CabRideListScreen({
    Key? key,
    required this.cabRides,
    required this.viewModel,
  }) : super(key: key);

  @override
  _CabRideListScreenState createState() => _CabRideListScreenState();
}

class _CabRideListScreenState extends State<CabRideListScreen> {
  String idFilter = '';
  String startTimeFilter = '';

  @override
  Widget build(BuildContext context) {
    List<Cab_ride> filteredCabRides = widget.cabRides.where((cabRide) {
      return cabRide.ID.contains(idFilter) &&
          cabRide.ride_start_time.contains(startTimeFilter);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Thông tin chuyến đi', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          _buildSearchSection(),
          _buildCabRideCount(filteredCabRides.length),
          _buildCabRideTable(filteredCabRides),
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
            child: _buildSoftSearchField(
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
            child: _buildSoftSearchField(
              label: 'Tìm kiếm theo thời gian khởi hành',
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

  Widget _buildCabRideCount(int count) {
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

  Widget _buildCabRideTable(List<Cab_ride> cabRides) {
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
                  'Thời gian khởi hành',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
            rows: cabRides.map((cabRide) {
              return DataRow(cells: [
                DataCell(
                  GestureDetector(
                    onTap: () {
                      widget.viewModel.fetchEachCabRide(context, cabRide.ID);
                    },
                    child: Text(
                      cabRide.ID,
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
                    cabRide.ride_start_time,
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

class CabRideDetailScreen extends StatelessWidget {
  final FullCabRide cabRide;
  final ShiftDashboardViewModel shiftViewModel = ShiftDashboardViewModel();
  final UserDashboardViewModel userViewModel = UserDashboardViewModel();

  CabRideDetailScreen({Key? key, required this.cabRide}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double baseFontSize = 16.0;
    final double increasedFontSize = baseFontSize * 1.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin chi tiết chuyến đi'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildDetailText('ID chuyến đi: ', cabRide.ID),
            SizedBox(height: 8),
            _buildDetailText('ID ca làm việc: ', cabRide.shift_id, isLink: true,
                onTap: () {
              shiftViewModel.fetchEachShift(context, cabRide.shift_id);
            }),
            SizedBox(height: 8),
            _buildDetailText('ID người dùng: ', cabRide.user_id, isLink: true,
                onTap: () {
              userViewModel.fetchEachUser(context, cabRide.user_id);
            }),
            SizedBox(height: 8),
            _buildDetailText(
                'Thời gian bắt đầu: ', cabRide.ride_start_time.toString()),
            SizedBox(height: 8),
            _buildDetailText(
                'Thời gian kết thúc: ', cabRide.ride_end_time.toString()),
            SizedBox(height: 8),
            _buildDetailText(
                'Điểm khởi hành: ', cabRide.address_starting_point),
            SizedBox(height: 8),
            _buildDetailText('GPS khởi hành: ', cabRide.GPS_starting_point),
            SizedBox(height: 8),
            _buildDetailText('Điểm đến: ', cabRide.address_destination),
            SizedBox(height: 8),
            _buildDetailText('GPS điểm đến: ', cabRide.GPS_destination),
            SizedBox(height: 8),
            _buildDetailText('Bị hủy: ', cabRide.canceled.toString()),
            SizedBox(height: 8),
            _buildDetailText('ID loại thanh toán: ', cabRide.payment_type_id),
            SizedBox(height: 8),
            _buildDetailText('Giá: ', cabRide.price.toString()),
            SizedBox(height: 8),
            _buildDetailText('Phản hồi: ', cabRide.response),
            SizedBox(height: 8),
            _buildDetailText('Đánh giá: ', cabRide.evaluate),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailText(String label, String value,
      {bool isLink = false, Function()? onTap}) {
    final double fontSize = 16.0;
    return RichText(
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
          isLink
              ? WidgetSpan(
                  child: GestureDetector(
                    onTap: onTap,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: fontSize,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                )
              : TextSpan(
                  text: value,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fontSize,
                  ),
                ),
        ],
      ),
    );
  }
}
