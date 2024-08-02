// ignore_for_file: library_private_types_in_public_api, unnecessary_new, unused_field, prefer_typing_uninitialized_variables

import "package:flutter/material.dart";
import 'package:flutter_app/user/models/place_item_res.dart';
import "../widget/home_menu.dart";
import "../widget/ride_picker.dart";
import '../../models/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../viewmodels/gg_marker.dart';
import '../../models/trip_info_res.dart';
import '../../services/place_services.dart';

class HomePage extends StatefulWidget {
  final User user;
  HomePage({required this.user});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _tripDistance = 0;
  final Map<String, Marker> _markers = <String, Marker>{};
  late LatLng _initialLocation = LatLng(0, 0);
  GoogleMapController? _mapController;
  Set<Marker> _marker = {};
  Set<Polyline> _polylines = {};

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final customIcon =
        await MarkerGenerator.createCustomMarkerBitmap(50, Colors.blue);
    setState(() {
      _initialLocation = LatLng(position.latitude, position.longitude);
      _marker.clear();
      _marker.add(Marker(
          markerId: MarkerId("currentLocation"),
          position: _initialLocation,
          icon: customIcon));
    });
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(_initialLocation));
    }
    print(_initialLocation);
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              zoomControlsEnabled: true,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              markers: _marker,
              initialCameraPosition:
                  CameraPosition(target: _initialLocation, zoom: 15),
            ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Column(
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    title: Text(
                      "Taxi app",
                      style: TextStyle(color: Colors.black),
                    ),
                    leading: TextButton(
                        onPressed: () {
                          print("Click menu");
                          //    Scaffold.of(context).openDrawer();
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        child: Image.asset("assets/user/menu.png")),
                    actions: <Widget>[Image.asset("assets/user/bell.png")],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: RidePicker(onPlaceSelected),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: HomeMenu(user: widget.user),
      ),
    );
  }

  void onPlaceSelected(PlaceItemRes place, bool fromAddress) {
    var mkId = fromAddress ? "from_address" : "to_address";
    _addMarker(mkId, place);
    _moveCamera();
    _checkDrawPolyline();
  }

  void _addMarker(String mkId, PlaceItemRes place) async {
    _markers.remove(mkId);

    final marker = Marker(
      markerId: MarkerId(mkId),
      position: LatLng(place.lat, place.lng),
      infoWindow: InfoWindow(title: place.name, snippet: place.address),
    );
    setState(() {
      _markers[mkId] = marker;
    });
  }

  void _moveCamera() {
    print("move camera: ");
    print(_markers);
    if (_markers.length > 1) {
      final fromMarker = _markers["from_address"];
      final toMarker = _markers["to_address"];

      if (fromMarker != null && toMarker != null) {
        final fromLatLng = fromMarker.position;
        final toLatLng = toMarker.position;

        var sLat, sLng, nLat, nLng;
        if (fromLatLng.latitude <= toLatLng.latitude) {
          sLat = fromLatLng.latitude;
          nLat = toLatLng.latitude;
        } else {
          sLat = toLatLng.latitude;
          nLat = fromLatLng.latitude;
        }

        if (fromLatLng.longitude <= toLatLng.longitude) {
          sLng = fromLatLng.longitude;
          nLng = toLatLng.longitude;
        } else {
          sLng = toLatLng.longitude;
          nLng = fromLatLng.longitude;
        }

        final bounds = LatLngBounds(
          northeast: LatLng(nLat, nLng),
          southwest: LatLng(sLat, sLng),
        );

        _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      }
    } else if (_markers.isNotEmpty) {
      final firstMarker = _markers.values.first;
      _mapController
          ?.animateCamera(CameraUpdate.newLatLng(firstMarker.position));
    }
  }

  void _checkDrawPolyline() async {
    //  remove old polyline
    setState(() {
      _polylines.clear();
    });

    if (_markers.length > 1) {
      var from = _markers["from_address"]!.position;
      var to = _markers["to_address"]!.position;
      try {
        TripInfoRes? infoRes = await PlaceService.getStep(
            from.latitude, from.longitude, to.latitude, to.longitude);
        if (infoRes != null) {
          _tripDistance = infoRes.distance;
          List<LatLng> paths = [];
          for (var t in infoRes.steps) {
            paths.add(
                LatLng(t.startLocation.latitude, t.startLocation.longitude));
            paths.add(LatLng(t.endLocation.latitude, t.endLocation.longitude));
          }
          Polyline polyline = Polyline(
              polylineId: PolylineId("route1"),
              points: paths,
              color: Colors.blue,
              width: 5);
          setState(() {
            _polylines.add(polyline);
          });
        }
      } catch (e) {
        print("Failed to draw polyline: $e");
      }
    }
  }
}
