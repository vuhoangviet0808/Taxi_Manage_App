// ignore_for_file: library_private_types_in_public_api

import "package:flutter/material.dart";
import "package:flutter_app/user/views/widget/update_user_widget.dart";

import "../../models/user.dart";

class UpdateUserPage extends StatefulWidget {
  final User user;
  UpdateUserPage({required this.user});
  @override
  _UpdateUserPageState createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
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
              right: 0,
              top: 0,
              child: Column(
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    title: Text(
                      "Taxi app",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, right: 20, left: 20),
              child: UpdateUserWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
