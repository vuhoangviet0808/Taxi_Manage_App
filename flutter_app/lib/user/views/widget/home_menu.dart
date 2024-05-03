import "package:flutter/material.dart";
import "../page/user_page.dart";
import "../../../common/views/login_page.dart";
import "../../models/user.dart";

class HomeMenu extends StatefulWidget {
  final User user;
  HomeMenu({Key? key, required this.user}) : super(key: key);

  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => UserPage(user: widget.user))
            );
          },
          child: ListTile(
            leading: Image.asset("assets/user/userlogin.png"),
            title: Text(
              "My profile",
              style: TextStyle(fontSize: 18, color: Color(0xff323643)),
            ),
          ),
        ),
        ListTile(
          leading: Image.asset("assets/user/refresh-ccw.png"),
          title: Text(
            "Ride History",
            style: TextStyle(fontSize: 18, color: Color(0xff323643)),
          )
        ),
        ListTile(
          leading: Image.asset("assets/user/percent.png"),
          title: Text(
            "Offers",
            style: TextStyle(fontSize: 18, color: Color(0xff323643)),
          )
        ),
        ListTile(
          leading: Image.asset("assets/user/whitebell.png"),
          title: Text(
            "Notifications",
            style: TextStyle(fontSize: 18, color: Color(0xff323643)),
          )
        ),
        ListTile(
          leading: Image.asset("assets/user/help-circle.png"),
          title: Text(
            "Help & support",
            style: TextStyle(fontSize: 18, color: Color(0xff323643)),
          )
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => LoginPage())
            );
          },
          child: ListTile(
            leading: Image.asset("assets/user/log-out.png"),
            title: Text(
              "Log out",
              style: TextStyle(fontSize: 18, color: Color(0xff323643)),
            )
          ),
        )
      ],
    );
  }
}