import 'package:flutter/material.dart';

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
            SizedBox(
              height: 80,
              child: Row(
                children: [
                  Image(
                    image: AssetImage('assets/commnon/user.png'),
                    width: 200,
                    height: 60,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Bạn là...',
                      style: TextStyle(
                      fontSize: 16,
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
            ElevatedButton(
              onPressed: () {
                if (firstnameController.text.isNotEmpty || lastnameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Thành công"),
                    ),
                  );
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
