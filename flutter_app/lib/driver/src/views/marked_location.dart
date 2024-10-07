// // ignore_for_file: library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'location_infor.dart';

// class MarkedLocations extends StatefulWidget {
//   @override
//   _MarkedLocationsState createState() => _MarkedLocationsState();
// }

// class _MarkedLocationsState extends State<MarkedLocations> {
//   List<Marker> _markers = [];
//   List<LatLng> _locations = [];
//   List<String> _notes = [];

//   Future<void> _fetchLocationInfo(LatLng point) async {
//     final url = Uri.parse(
//         'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${point.latitude}&lon=${point.longitude}');
//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       String displayName = data['display_name'] ?? 'No address found';
//       _showInfoDialog(point, displayName);
//     } else {
//       _showInfoDialog(point, 'Failed to fetch address');
//     }
//   }

//   void _addMarker(LatLng point) {
//     TextEditingController _noteController = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Thêm ghi chú"),
//           content: TextField(
//             controller: _noteController,
//             decoration:
//                 InputDecoration(hintText: "Nhập ghi chú cho địa điểm này"),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text("Hủy"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text("Thêm"),
//               onPressed: () {
//                 setState(() {
//                   _locations.add(point);
//                   _notes.add(_noteController.text);
//                   _markers.add(
//                     Marker(
//                       point: point,
//                       builder: (ctx) => GestureDetector(
//                         onTap: () => _fetchLocationInfo(point),
//                         child: Icon(Icons.location_on,
//                             color: Colors.red, size: 40),
//                       ),
//                     ),
//                   );
//                 });
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showInfoDialog(LatLng point, String info) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return LocationInfoDialog(
//           title: 'Thông tin địa điểm',
//           description: info,
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Đánh dấu và ghi chú địa chỉ"),
//         backgroundColor: Colors.teal,
//       ),
//       body: FlutterMap(
//         options: MapOptions(
//           center: LatLng(10.762622, 106.660172),
//           zoom: 13,
//           onTap: (tapPosition, point) => _addMarker(point),
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//             subdomains: ['a', 'b', 'c'],
//           ),
//           MarkerLayer(
//             markers: _markers,
//           ),
//         ],
//       ),
//     );
//   }
// }
