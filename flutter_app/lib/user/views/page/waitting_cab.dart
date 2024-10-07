import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../page/got_driver.dart';
import '../../services/user_info_services.dart';
import '../../models/user.dart';
import '../page/home_page.dart';

class WaitingCab extends StatefulWidget {
  final LatLng pickupLocation;
  final LatLng destinationLocation;
  final String pickupAddress;
  final String destinationAddress;
  final User user;
  final double totalDistance;

  WaitingCab({
    required this.pickupLocation,
    required this.destinationLocation,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.user,
    required this.totalDistance,
  });

  @override
  State<WaitingCab> createState() => _WaitingCabState();
}

class _WaitingCabState extends State<WaitingCab> {
  late LatLng _initialLocation;
  MapController _mapController = MapController();
  List<LatLng> _routePoints = [];
  int? _latestBookingID;
  int? _driverID;
  final BookingInfoService _bookingInfoService = BookingInfoService();
  final BookingService _bookingService = BookingService();

  Future<void> _fetchLatestBookingId() async {
    try {
      final bookingID = await _bookingInfoService.getLatestBookingID(widget.user.User_ID);
      setState(() {
        _latestBookingID = bookingID;
      });
    } catch (e) {
      print('Error fetching latest booking ID: $e');
    }
  }

  Future<void> _fetchDriverId() async {
    if (_latestBookingID != null) {
      try {
        final driverID = await _bookingInfoService.getDriverIdByLatestBooking(_latestBookingID!);
        setState(() {
          _driverID = driverID;
        });
        if (driverID != null) {
          print("Driver ID: $driverID");
        } else {
          print("No driver assigned for this booking.");
        }
      } catch (e) {
        print('Error fetching driver ID: $e');
      }
    }
  }

  void getLocation() async {
    try {
      await Geolocator.checkPermission();
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _initialLocation = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_initialLocation, 15.0);
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  Future<void> _fetchRoute(LatLng start, LatLng end) async {
    final url = Uri.parse(
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf6248d8a744a453db40818a2f60624aebb033&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> coordinates =
          data['features'][0]['geometry']['coordinates'];
      setState(() {
        _routePoints =
            coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
      });
    } else {
      print("Failed to fetch route: ${response.body}");
    }
  }

  @override
  void initState() {
    super.initState();
    print("initState called");
    _initialLocation = widget.pickupLocation;
    _fetchRoute(widget.pickupLocation, widget.destinationLocation);
    _fetchLatestBookingId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _initialLocation,
              zoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints,
                    color: Colors.blue,
                    strokeWidth: 4.0,
                  )
                ],
              ),
            ],
          ),
          SlidingUpPanel(
            panel: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "Finding Driver",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Divider(color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Booking ID",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _latestBookingID != null ? _latestBookingID.toString() : 'Waiting...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      _buildAddressBox(
                        icon: Icons.location_on, // Thay biểu tượng location_on
                        address: widget.pickupAddress,
                      ),
                      SizedBox(height: 8),
                      _buildAddressBox(
                        icon: Icons.location_on, // Thay biểu tượng location_on
                        address: widget.destinationAddress,
                      ),

                      SizedBox(height: 16),

                      // Nút "Confirm Ride"
                      SizedBox(
                        width: double.infinity, // Chiều rộng toàn bộ
                        child: ElevatedButton(
                          onPressed: () async {
                            await _fetchDriverId();

                            if (_driverID != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GotDriver(
                                    pickupLocation: widget.pickupLocation,
                                    destinationLocation: widget.destinationLocation,
                                    pickupAddress: widget.pickupAddress,
                                    destinationAddress: widget.destinationAddress,
                                    driverID: _driverID!,
                                    totalDistance: widget.totalDistance,
                                    user: widget.user,
                                  ),
                                ),
                              );
                            } else {
                              print("No driver found.");
                            }
                          },
                          child: Text("Confirm Ride"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal, // Background color
                            foregroundColor: Colors.white, // Text color
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0), // Giảm padding dọc
                            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Giảm kích thước chữ
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      // Nút "Cancel Ride"
                      SizedBox(
                        width: double.infinity, // Chiều rộng toàn bộ
                        child: ElevatedButton(
                          onPressed: () async {
                            final bool isCancelled = await _bookingService.cancelLatestBooking(widget.user.User_ID);
                            if (isCancelled) {
                              print("Ride has been cancelled successfully.");
                              
                              // Điều hướng người dùng quay lại trang HomePage và xoá tất cả các màn hình trước đó
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(user: widget.user),
                                ),
                                (Route<dynamic> route) => false, // Xoá tất cả các route trước đó
                              );
                            } else {
                              print("Failed to cancel the ride.");
                            }
                          },
                          child: Text("Cancel Ride"),  // Thay đổi thành "Cancel Ride"
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,  // Nút màu đỏ
                            foregroundColor: Colors.white, // Text color
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0), // Giảm padding dọc
                            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Giảm kích thước chữ
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(18.0)),
            minHeight: 200,
            maxHeight: 550,
            body: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressBox({required IconData icon, required String address}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.teal), // Thay đổi thành location_on
          SizedBox(width: 8),
          Expanded(
            child: Text(
              address,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceBox({required double totalDistance}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.directions_car, size: 24, color: Colors.teal),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Distance: ${totalDistance.toStringAsFixed(2)} km',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
