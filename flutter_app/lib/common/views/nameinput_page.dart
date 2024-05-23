import 'package:flutter/material.dart';
import './sexinput_page.dart';

class NameInputPage extends StatefulWidget {
  final String phoneNumber;

  NameInputPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _NameInputPageState createState() => _NameInputPageState();
}

class _NameInputPageState extends State<NameInputPage> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

  String _nameError = "";


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
              "Chào mừng bạn đến với ...",
            style: TextStyle(color: Colors.purple, fontSize: 20, fontWeight: FontWeight.bold ),
            ),
            SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text(
                      'Tên của bạn là...',
                      style: TextStyle(
                      fontSize: 16,
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            if (_nameError.isNotEmpty)
              Text(
                _nameError,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            TextField(
              controller: firstnameController,
              decoration: InputDecoration(
                labelText: "Họ",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffCED0D2), width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: lastnameController,
              decoration: InputDecoration(
                labelText: "Tên",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffCED0D2), width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (firstnameController.text.isNotEmpty && lastnameController.text.isNotEmpty) {
                  Navigator.push(context,
                MaterialPageRoute(builder: (context) => SexInputPage(phoneNumber: widget.phoneNumber, firstname: firstnameController.text, lastname: lastnameController.text )));
                } else {
                  setState(() {
                    _nameError = "Vui lòng không để trống tên";
                  });
                }
              },
              child: Text("Tiếp tục"),
            ),
          ],
        ),
      ),
    );
  }
}
