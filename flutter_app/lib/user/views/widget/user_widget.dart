import "package:flutter/material.dart";
import '../../models/user.dart';

class UserWidget extends StatefulWidget {
  final User user;

  UserWidget({Key? key, required this.user}) : super(key: key);

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<UserWidget> {
  @override
  Widget build(BuildContext context) {
    User user = widget.user;

    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
             Padding(
                padding: const EdgeInsets.fromLTRB(0, 80, 0, 20),
                child: TextField(
                  style: TextStyle(fontSize: 18,color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "${user.firstname} ${user.lastname}",
                    prefixIcon: SizedBox(
                        width: 50, child: Image.asset("assets/user/user.png")),
                        border: OutlineInputBorder(
                          borderSide: 
                          BorderSide(color: Color(0xffCED0D2), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
              ),
              TextField(
                  style: TextStyle(fontSize: 18,color: Colors.black),
                  decoration: InputDecoration(
                    labelText: user.SDT,
                    prefixIcon: SizedBox(
                        width: 50, child: Image.asset("assets/user/phone.png")),
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
                    labelText: user.DOB.toString(),
                    prefixIcon: SizedBox(
                        width: 50, child: Image.asset("assets/user/mail.png")),
                        border: OutlineInputBorder(
                          borderSide: 
                          BorderSide(color: Color(0xffCED0D2), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
              ),
            TextField(
                  style: TextStyle(fontSize: 18,color: Colors.black),
                  decoration: InputDecoration(
                    labelText: user.Address,
                    prefixIcon: SizedBox(
                        width: 50, child: Image.asset("assets/user/lock.png")),
                        border: OutlineInputBorder(
                          borderSide: 
                          BorderSide(color: Color(0xffCED0D2), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
              TextField(
                  style: TextStyle(fontSize: 18,color: Colors.black),
                  decoration: InputDecoration(
                    labelText: user.gender,
                    prefixIcon: SizedBox(
                        width: 50, child: Image.asset("assets/user/lock.png")),
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