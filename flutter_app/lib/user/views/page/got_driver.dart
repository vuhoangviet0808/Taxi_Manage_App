import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../page/ratingscreen.dart'; // Import RatingScreen page
import '../../services/user_info_services.dart';
import '../../models/user.dart';

class GotDriver extends StatefulWidget {
  final LatLng pickupLocation;
  final LatLng destinationLocation;
  final String pickupAddress;
  final String destinationAddress;
  final int driverID;
  final double totalDistance;
  final User user;

  GotDriver({
    required this.pickupLocation,
    required this.destinationLocation,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.driverID,
    required this.totalDistance,
    required this.user,
  });

  @override
  State<GotDriver> createState() => _GotDriverState();
}

class _GotDriverState extends State<GotDriver> {
  late LatLng _initialLocation;
  MapController _mapController = MapController();
  List<LatLng> _routePoints = [];
  final CabRideInfoService _cabRideInfoService = CabRideInfoService();

  String _licencePlate = '';
  String _carType = '';
  String _driverName = '';
  String _driverPhone = '';
  double _driverEvaluate = 0.0;

  int calculateEstimatedTime(double distance, double speed) {
    double timeInHours = distance / speed;
    int timeInMinutes = (timeInHours * 60).ceil();
    return timeInMinutes;
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
      print("Error getting location: $e");
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

  Future<void> _checkCabRideStatus() async {
    try {
      final cabRide = await _cabRideInfoService.getCabRideByDriverId(widget.driverID);

      if (cabRide != null && cabRide.status == 'completed') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RatingScreen(
              totalDistance: widget.totalDistance,
              cabRideId: cabRide.id,
              user: widget.user,
            ),
          ),
        );
      } else {
        print('Cab ride is not completed yet.');
      }
    } catch (e) {
      print('Error occurred while checking cab ride status: $e');
    }
  }

  Future<void> _fetchCabInfo() async {
    try {
      final cab = await _cabRideInfoService.getCabByDriverId(widget.driverID);
      if (cab != null) {
        setState(() {
          _licencePlate = cab.licence_plate;
          _carType = cab.car_type == '4_seat' ? '4-seat Car' : '6-seat Car';
        });
      }
    } catch (e) {
      print('Error fetching cab info: $e');
    }
  }

  Future<void> _fetchDriverInfo() async {
    try {
      final driver = await _cabRideInfoService.getDriverById(widget.driverID);
      if (driver != null) {
        setState(() {
          _driverName = '${driver.Firstname} ${driver.Lastname}';
          _driverPhone = driver.SDT;
        });
      }
    } catch (e) {
      print('Error fetching driver info: $e');
    }
  }

  Future<void> _fetchDriverEvaluate() async {
    try {
      double? evaluate = await _cabRideInfoService.getEvaluateByDriverId(widget.driverID);
      if (evaluate != null) {
        setState(() {
          _driverEvaluate = evaluate;
        });
      }
    } catch (e) {
      print('Error fetching driver evaluate: $e');
    }
  }

  Widget buildStarRating(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return Icon(Icons.star, color: Colors.amber, size: 16);
        } else if (index == fullStars && hasHalfStar) {
          return Icon(Icons.star_half, color: Colors.amber, size: 16);
        } else {
          return Icon(Icons.star_border, color: Colors.amber, size: 16);
        }
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    _initialLocation = widget.pickupLocation;
    _fetchRoute(widget.pickupLocation, widget.destinationLocation);
    _fetchCabInfo();
    _fetchDriverInfo();
    _fetchDriverEvaluate();
  }

  @override
  Widget build(BuildContext context) {
    int estimatedTime = calculateEstimatedTime(widget.totalDistance, 40);

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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "$estimatedTime minutes",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Your driver is on the way.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Divider(color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "$_licencePlate - $_carType",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_taxi,
                        size: 48,
                        color: Colors.teal,
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _driverName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          buildStarRating(_driverEvaluate),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.phone, color: Colors.teal),
                        onPressed: () {
                          showDialog(
  context: context,
  builder: (BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Bo tròn góc dialog
        side: BorderSide(color: Colors.teal, width: 2), // Viền teal
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Để nội dung khớp với kích thước
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Driver Phone Number',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal, // Màu teal cho tiêu đề
              ),
            ),
            SizedBox(height: 16),
            Text(
              _driverPhone, // Số điện thoại tài xế
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog khi bấm nút OK
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Nút OK màu teal
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Bo góc nút OK
                ),
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white, // Chữ trắng trên nút OK
                ),
              ),
            ),
          ],
        ),
      ),
    );
  },
);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.message, color: Colors.teal),
                        onPressed: () {
                          // Implement message functionality
                        },
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _checkCabRideStatus();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Complete Ride",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(18.0)),
            minHeight: 200,
            maxHeight: 350,
            body: Container(),
          ),
        ],
      ),
    );
  }
}
