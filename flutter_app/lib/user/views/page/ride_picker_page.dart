// import 'package:flutter/material.dart';

// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

// class RiderPickerPage extends StatefulWidget {
//   @override
//   State<RiderPickerPage> createState() => _RiderPickerPageState();
// }

// class _RiderPickerPageState extends State<RiderPickerPage> {
//    final LatLng _center = LatLng(45.521563, -122.677433);
//   late MapController mapController;

//   @override
//   void initState() {
//     super.initState();
//     mapController = MapController();
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Điểm đến'),
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: [
//           FlutterMap(
//             options: MapOptions(
//               initialCenter: _center,
//               initialZoom: 11,
//               interactionOptions: const InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom),
//             ),
//             children: [
//               openStreetMapTileLayer,
//             ],
//           ),
          
//           DraggableScrollableSheet(
//             initialChildSize: 0.3,
//             minChildSize: 0.1,
//             maxChildSize: 0.9,
//             builder: (BuildContext context, ScrollController scrollController) {
//               return Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(16.0),
//                     topRight: Radius.circular(16.0),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 10.0,
//                       spreadRadius: 0.5,
//                       offset: Offset(0, -2),
//                     ),
//                   ],
//                 ),
//                 child: SingleChildScrollView(
//                   controller: scrollController,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         Container(
//                           margin: const EdgeInsets.only(bottom: 16.0),
//                           width: 40,
//                           height: 4,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             borderRadius: BorderRadius.circular(2.0),
//                           ),
//                         ),
//                         Text(
//                           'Điểm đến',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 16.0),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.teal),
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(Icons.location_on, color: Colors.black),
//                               SizedBox(width: 8.0),
//                               Expanded(
//                                 child: TextField(
//                                   decoration: InputDecoration(
//                                     hintText: 'Bạn hãy nhập điểm đến',
//                                     border: InputBorder.none,
//                                   ),
//                                   style: TextStyle(fontSize: 16.0),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 16.0),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.teal),
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(Icons.location_on, color: Colors.orange),
//                               SizedBox(width: 8.0),
//                               Expanded(
//                                 child: TextField(
//                                   decoration: InputDecoration(
//                                     hintText: 'Tới điểm?',
//                                     border: InputBorder.none,
//                                   ),
//                                   style: TextStyle(fontSize: 16.0),
//                                 ),
//                               ),
//                               IconButton(
//                                 onPressed: () {},
//                                 icon: Icon(Icons.add, color: Colors.teal),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 16.0),
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: () {},
//                             child: Text('Xác nhận đặt chuyến'),
//                             style: ElevatedButton.styleFrom(
//                               padding: EdgeInsets.symmetric(vertical: 16.0),
//                               backgroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30.0),
//                               ),
//                               textStyle: TextStyle(color: Colors.black, fontSize: 15),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 16.0),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             _buildCategoryButton(Icons.home, 'Thêm Nhà'),
//                             _buildCategoryButton(Icons.business, 'Thêm Công ty'),
//                             _buildCategoryButton(Icons.location_city, 'Thêm địa chỉ'),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryButton(IconData icon, String label) {
//     return Column(
//       children: [
//         CircleAvatar(
//           backgroundColor: Colors.teal.withOpacity(0.1),
//           child: Icon(icon, color: Colors.teal),
//         ),
//         SizedBox(height: 4.0),
//         Text(label, style: TextStyle(fontSize: 14.0)),
//       ],
//     );
//   }
// }
// TileLayer get openStreetMapTileLayer => TileLayer(
//   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//   userAgentPackageName: 'dev.fleaflet.flutter_map.example',
// );