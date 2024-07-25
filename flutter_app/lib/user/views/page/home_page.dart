// ignore_for_file: library_private_types_in_public_api, unnecessary_new

import 'package:flutter/material.dart';
import '../widget/home_menu.dart';
import '../widget/ride_picker.dart';
import '../../models/user.dart';


class HomePage extends StatefulWidget {
  final User user;
  HomePage({required this.user});
  @override
  State<HomePage> createState() => _HomePageState();
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
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Column(
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    titleSpacing: 0,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Text(
                          "Taxi app",
                          style: TextStyle(color: Colors.black),
                        ),
                        Spacer(),
                      ],
                    ),
                    leading: IconButton(
                      icon: Image.asset("assets/user/menu.png"),
                      onPressed: () {
                        print("Click menu");
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                    actions: [
                      IconButton(
                        icon: Image.asset("assets/user/bell.png"),
                        onPressed: () {
                          // Handle bell icon press
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: RidePicker(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: HomeMenu(user: widget.user),
      ),
    );
  }
}
