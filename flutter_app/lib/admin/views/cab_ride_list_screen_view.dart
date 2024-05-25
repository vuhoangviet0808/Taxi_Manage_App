import 'package:flutter/material.dart';
import 'package:flutter_app/admin/viewmodels/cab_ride_viewmodels.dart';
import 'package:flutter_app/admin/models/cab_ride_model.dart';

class CabRideListScreen extends StatefulWidget {
  final List<Cab_ride> cabRides;
  final CabRideDashboardViewModel viewModel;

  const CabRideListScreen(
      {Key? key, required this.cabRides, required this.viewModel})
      : super(key: key);

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
        title: Text('Quản lí chuyến đi'),
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
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Start Time',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ],
                  rows: filteredCabRides.map((cabRide) {
                    return DataRow(cells: [
                      DataCell(
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () {
                              widget.viewModel
                                  .fetchEachCabRide(context, cabRide.ID);
                            },
                            child: Text(
                              cabRide.ID,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.all(8),
                          child: Text(
                            cabRide.ride_start_time,
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

class CabRideDetailScreen extends StatelessWidget {
  final FullCabRide cabRide;

  const CabRideDetailScreen({Key? key, required this.cabRide})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin chi tiết chuyến đi'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'ID chuyến đi: ${cabRide.ID}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('ID ca làm việc: ${cabRide.shift_id}'),
            SizedBox(height: 8),
            Text('ID người dùng: ${cabRide.user_id}'),
            SizedBox(height: 8),
            Text('Thời gian bắt đầu: ${cabRide.ride_start_time.toString()}'),
            SizedBox(height: 8),
            Text('Thời gian kết thúc: ${cabRide.ride_end_time.toString()}'),
            SizedBox(height: 8),
            Text('Điểm khởi hành: ${cabRide.address_starting_point}'),
            SizedBox(height: 8),
            Text('GPS khởi hành: ${cabRide.GPS_starting_point}'),
            SizedBox(height: 8),
            Text('Điểm đến: ${cabRide.address_destination}'),
            SizedBox(height: 8),
            Text('GPS điểm đến: ${cabRide.GPS_destination}'),
            SizedBox(height: 8),
            Text('Bị hủy: ${cabRide.canceled}'),
            SizedBox(height: 8),
            Text('ID loại thanh toán: ${cabRide.payment_type_id}'),
            SizedBox(height: 8),
            Text('Giá: ${cabRide.price}'),
            SizedBox(height: 8),
            Text('Phản hồi: ${cabRide.response}'),
            SizedBox(height: 8),
            Text('Đánh giá: ${cabRide.evaluate}'),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
