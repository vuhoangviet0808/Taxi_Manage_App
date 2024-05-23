import 'package:flutter/material.dart';
import './DOBinput_page.dart';

class SexInputPage extends StatefulWidget {
  final String phoneNumber;
  final String firstname;
  final String lastname;

  SexInputPage({required this.phoneNumber,required this.firstname,required this.lastname});

  @override
  _SexInputPageState createState() => _SexInputPageState();
}

class _SexInputPageState extends State<SexInputPage> {
  String selectedSex = "Nam";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xff3277D8)),
        elevation: 0,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Bạn là:",
              style: TextStyle(
                fontSize: 16,
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSex = "Nam";
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: selectedSex == "Nam" ? Colors.purple : Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                      color: selectedSex == "Nam" ? Colors.purple : Colors.transparent,
                    ),
                    child: Text(
                      "Nam",
                      style: TextStyle(
                        color: selectedSex == "Nam" ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSex = "Nữ";
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: selectedSex == "Nữ" ? Colors.purple : Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                      color: selectedSex == "Nữ" ? Colors.purple : Colors.transparent,
                    ),
                    child: Text(
                      "Nữ",
                      style: TextStyle(
                        color: selectedSex == "Nữ" ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => 
                    DOBInputPage(phoneNumber: widget.phoneNumber, firstname: widget.firstname, lastname: widget.lastname, sex: selectedSex )));
              },
              child: Text("Tiếp tục"),
            ),
          ],
        ),
      ),
    );
  }
}
