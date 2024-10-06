// import 'package:flutter/material.dart';
// import 'package:flutter_app/admin/models/driver_by_revenue_model.dart';
// import 'package:flutter_app/admin/models/models.dart';
// import 'package:flutter_app/admin/viewmodels/viewmodels.dart';
// import 'package:flutter_app/admin/views/driver_revenue_detail_view.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class DriverRevenueReportScreenView extends StatefulWidget {
//   final List<Driver> drivers;
//   final AdminDashboardViewModel viewModel;

//   const DriverRevenueReportScreenView(
//       {Key? key, required this.drivers, required this.viewModel})
//       : super(key: key);

//   @override
//   _DriverRevenueReportScreenViewState createState() =>
//       _DriverRevenueReportScreenViewState();
// }

// class _DriverRevenueReportScreenViewState
//     extends State<DriverRevenueReportScreenView> {
//   String nameFilter = '';
//   String idFilter = '';
//   DateTime? startDate;
//   DateTime? endDate;
//   List<Driver> sortedDrivers = [];
//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     List<Driver> filteredDrivers = widget.drivers.where((driver) {
//       return (driver.Firstname.toLowerCase()
//                   .contains(nameFilter.toLowerCase()) ||
//               driver.Lastname.toLowerCase()
//                   .contains(nameFilter.toLowerCase())) &&
//           driver.Driver_ID.contains(idFilter);
//     }).toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Thông tin tài xế'),
//       ),
//       body: Column(
//         children: [
//           ExpansionTile(
//             title: Text("Tìm kiếm"),
//             leading: Icon(Icons.search),
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextField(
//                   onChanged: (value) {
//                     setState(() {
//                       idFilter = value;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     labelText: 'Tìm kiếm theo ID',
//                     prefixIcon: Icon(Icons.search),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextField(
//                   onChanged: (value) {
//                     setState(() {
//                       nameFilter = value;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     labelText: 'Tìm kiếm theo tên',
//                     prefixIcon: Icon(Icons.search),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GestureDetector(
//                   onTap: () async {
//                     final pickedDate = await _selectDate(context, startDate);
//                     if (pickedDate != null) {
//                       setState(() {
//                         startDate = pickedDate;
//                       });
//                     }
//                   },
//                   child: AbsorbPointer(
//                     child: TextField(
//                       decoration: InputDecoration(
//                         labelText: startDate != null
//                             ? DateFormat('dd-MM-yyyy').format(startDate!)
//                             : 'Ngày bắt đầu',
//                         prefixIcon: Icon(Icons.calendar_today),
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GestureDetector(
//                   onTap: () async {
//                     final pickedDate = await _selectDate(context, endDate);
//                     if (pickedDate != null) {
//                       setState(() {
//                         endDate = pickedDate;
//                       });
//                     }
//                   },
//                   child: AbsorbPointer(
//                     child: TextField(
//                       decoration: InputDecoration(
//                         labelText: endDate != null
//                             ? DateFormat('dd-MM-yyyy').format(endDate!)
//                             : 'Ngày kết thúc',
//                         prefixIcon: Icon(Icons.calendar_today),
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   if (startDate != null && endDate != null) {
//                     _fetchDriversRevenue();
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                             'Vui lòng chọn ngày bắt đầu và ngày kết thúc.'),
//                       ),
//                     );
//                   }
//                 },
//                 child: Text('Lọc theo doanh thu cao nhất'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     nameFilter = '';
//                     idFilter = '';
//                     startDate = null;
//                     endDate = null;
//                     sortedDrivers = [];
//                   });
//                 },
//                 child: Text('Reset'),
//               ),
//             ],
//           ),
//           if (isLoading) Center(child: CircularProgressIndicator()),
//           Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: DataTable(
//                   columnSpacing: MediaQuery.of(context).size.width - 200,
//                   columns: [
//                     DataColumn(
//                       label: Text(
//                         'ID',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 18),
//                       ),
//                     ),
//                     DataColumn(
//                       label: Text(
//                         'Họ tên',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 18),
//                       ),
//                     ),
//                   ],
//                   rows: (sortedDrivers.isNotEmpty
//                           ? sortedDrivers
//                           : filteredDrivers)
//                       .map((driver) {
//                     return DataRow(cells: [
//                       DataCell(
//                         Container(
//                           alignment: Alignment.centerLeft,
//                           padding: EdgeInsets.all(8),
//                           child: GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       DriverRevenueDetailScreen(
//                                           driverId: driver.Driver_ID),
//                                 ),
//                               );
//                             },
//                             child: Text(
//                               driver.Driver_ID,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 decoration: TextDecoration.underline,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         Container(
//                           alignment: Alignment.centerLeft,
//                           padding: EdgeInsets.all(8),
//                           child: Text(
//                             "${driver.Firstname} ${driver.Lastname}",
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         ),
//                       ),
//                     ]);
//                   }).toList(),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<DateTime?> _selectDate(
//       BuildContext context, DateTime? initialDate) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: initialDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     return pickedDate;
//   }

//   Future<void> _fetchDriversRevenue() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final response = await http.get(
//         Uri.parse(
//             'http://10.0.2.2:5000/admin/driver_by_revenue?start_date=${DateFormat('dd-MM-yyyy').format(startDate!)}&end_date=${DateFormat('dd-MM-yyyy').format(endDate!)}'),
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> revenueData =
//             json.decode(response.body)['driver_revenue_data'];

//         final List<DriverRevenue> driverRevenues =
//             revenueData.map((json) => DriverRevenue.fromJson(json)).toList();

//         driverRevenues.sort((a, b) => b.totalRevenue.compareTo(a.totalRevenue));

//         sortedDrivers = driverRevenues
//             .map((driverRevenue) => driverRevenue.toDriver())
//             .toList();

//         setState(() {
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Đã xảy ra lỗi khi tải dữ liệu.'),
//           ),
//         );
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Đã xảy ra lỗi khi tải dữ liệu: $e'),
//         ),
//       );
//     }
//   }
// }
