import "package:flutter/material.dart";
import "package:flutter_app/user/views/page/update_user_page.dart";

import "../widget/home_menu.dart";
import "../widget/user_widget.dart";
import '../../models/user.dart';

class UserPage extends StatefulWidget {
  final User user;

  UserPage({Key? key, required this.user}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
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
                      actions: <Widget>[ 
                        TextButton(
                          child: Text ("chinh sua",
                           style: TextStyle(color: Colors.black, fontSize: 12),
                           ),
                           onPressed: () {
                             Navigator.of(context).push(
                             MaterialPageRoute(builder: (context) => UpdateUserPage())
                              );
                           },
                           )
                      ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:20, left:20, right:20),
                    child: UserWidget(user: widget.user),
                  )
                ],
              ),
            )
          ],
        )
        
      ),
      drawer: Drawer(
        child: HomeMenu(user: widget.user),
      ),
    );
  }
}