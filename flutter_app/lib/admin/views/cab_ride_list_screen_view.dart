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
    final double baseFontSize = 16.0;
    final double increasedFontSize = baseFontSize * 1;

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
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'ID chuyến đi: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: increasedFontSize),
                  ),
                  TextSpan(
                    text: '${cabRide.ID}',
                    style: TextStyle(
                        color: Colors.black, fontSize: increasedFontSize),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'ID ca làm việc: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: increasedFontSize),
                  ),
                  TextSpan(
                    text: '${cabRide.shift_id}',
                    style: TextStyle(
                        color: Colors.black, fontSize: increasedFontSize),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'ID người dùng: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: increasedFontSize),
                  ),
                  TextSpan(
                    text: '${cabRide.user_id}',
                    style: TextStyle(
                        color: Colors.black, fontSize: increasedFontSize),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Thời gian bắt đầu: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: increasedFontSize),
                  ),
                  TextSpan(
                    text: '${cabRide.ride_start_time.toString()}',
                    style: TextStyle(
                        color: Colors.black, fontSize: increasedFontSize),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Thời gian kết thúc: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: increasedFontSize),
                  ),
                  TextSpan(
                    text: '${cabRide.ride_end_time.toString()}',
                    style: TextStyle(
                        color: Colors.black, fontSize: increasedFontSize),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Điểm khởi hành: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: increasedFontSize),
                  ),
                  TextSpan(
                    text: '${cabRide.address_starting_point}',
                    style: TextStyle(
                        color: Colors.black, fontSize: increasedFontSize),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'GPS khởi hành: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: increasedFontSize),
                  ),
                  TextSpan(
                    text: '${cabRide.GPS_starting_point}',
                    style: TextStyle(
                        color: Colors.black, fontSize: increasedFontSize),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Điểm đến: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: increasedFontSize),
                  ),
                  TextSpan(
                    text: '${cabRide.address_destination}',
                    style: TextStyle(
                        color: Colors.black, fontSize: increasedFontSize),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'GPS điểm đến: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: increasedFontSize),
                  ),
                  TextSpan(
                    text: '${cabRide.GPS_destination}',
                    style: TextStyle(
                        color: Colors.black, fontSize: increasedFontSize),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Bị hủy: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: increasedFontSize),
                  ),
                  TextSpan(
                    text: '${cabRide.canceled}',
                    style: TextStyle(
                        color: Colors.black, fontSize: increasedFontSize),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'ID loại thanh toán: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: increasedFontSize),
                  ),
                  TextSpan(
                    text: '${cabRide.payment_type_id}',
                    style: TextStyle(
                        color: Colors.black, fontSize: increasedFontSize),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Giá: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: increasedFontSize),
                  ),
                  TextSpan(
                    text: '${cabRide.price}',
                    style: TextStyle(
                        color: Colors.black, fontSize: increasedFontSize),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Phản hồi: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: increasedFontSize),
                  ),
                  TextSpan(
                    text: '${cabRide.response}',
                    style: TextStyle(
                        color: Colors.black, fontSize: increasedFontSize),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Đánh giá: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: increasedFontSize),
                  ),
                  TextSpan(
                    text: '${cabRide.evaluate}',
                    style: TextStyle(
                        color: Colors.black, fontSize: increasedFontSize),
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
