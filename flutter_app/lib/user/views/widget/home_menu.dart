import "package:flutter/material.dart";
import "../page/user_page.dart";
import "../../../common/views/login_page.dart";


class HomeMenu extends StatefulWidget {
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
              MaterialPageRoute(builder: (context) => UserPage())
            );
          },
          child: ListTile(
            leading: Image.asset("userlogin.png"),
            title: Text(
              "My profile",
              style: TextStyle(fontSize: 18, color: Color(0xff323643)),
            ),
          ),
        ),
        ListTile(
          leading: Image.asset("refresh-ccw.png"),
          title: Text(
            "Ride History",
            style: TextStyle(fontSize: 18, color: Color(0xff323643)),
          )
        ),
        ListTile(
          leading: Image.asset("percent.png"),
          title: Text(
            "Offers",
            style: TextStyle(fontSize: 18, color: Color(0xff323643)),
          )
        ),
        ListTile(
          leading: Image.asset("whitebell.png"),
          title: Text(
            "Notifications",
            style: TextStyle(fontSize: 18, color: Color(0xff323643)),
          )
        ),
        ListTile(
          leading: Image.asset("help-circle.png"),
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
            leading: Image.asset("log-out.png"),
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