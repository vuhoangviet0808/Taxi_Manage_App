// ignore_for_file: library_private_types_in_public_api, unnecessary_new

import "package:flutter/material.dart";
import "../widget/home_menu.dart";
import "../widget/ride_picker.dart";
import '../../models/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  final User user;

  HomePage({Key? key, required this.user}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
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
              initialCameraPosition: CameraPosition(
                target: LatLng(10.7915178, 106.7271422),
                zoom: 14.4746,
              ),
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
                      child: RidePicker())
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
}
