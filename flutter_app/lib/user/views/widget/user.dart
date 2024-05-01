import "package:flutter/material.dart";

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
             Padding(
                padding: const EdgeInsets.fromLTRB(0, 80, 0, 20),
                child: TextField(
                  style: TextStyle(fontSize: 18,color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Name",
                    prefixIcon: Container(
                        width: 50, child: Image.asset("user/user.png")),
                        border: OutlineInputBorder(
                          borderSide: 
                          BorderSide(color: Color(0xffCED0D2), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
              ),
              TextField(
                  style: TextStyle(fontSize: 18,color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Phone number",
                    prefixIcon: Container(
                        width: 50, child: Image.asset("user/phone.png")),
                        border: OutlineInputBorder(
                          borderSide: 
                          BorderSide(color: Color(0xffCED0D2), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: TextField(
                  style: TextStyle(fontSize: 18,color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: Container(
                        width: 50, child: Image.asset("user/mail.png")),
                        border: OutlineInputBorder(
                          borderSide: 
                          BorderSide(color: Color(0xffCED0D2), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
              ),
            TextField(
                  style: TextStyle(fontSize: 18,color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Container(
                        width: 50, child: Image.asset("user/lock.png")),
                        border: OutlineInputBorder(
                          borderSide: 
                          BorderSide(color: Color(0xffCED0D2), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
          ],
        ),
      )
    );
  }
}