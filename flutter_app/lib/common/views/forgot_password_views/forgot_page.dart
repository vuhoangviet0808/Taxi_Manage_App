// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _sdtController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xff3277D8)),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 6),
                child: Text(
                  "Tìm tài khoản",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only( bottom: 6),
                child: Text(
                  "Nhập số di động của bạn",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only( bottom: 6),
                child: TextField(
                  controller: _sdtController,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.7),
                  ),
                  decoration: InputDecoration(
                    labelText: "Số di động",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only( bottom: 6),
                child: Text(
                  "Chúng tôi có thể gửi thông báo qua SMS để phục vụ mục đích bảo mật và hỗ trợ bạn đăng nhập.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Xử lý khi nút bấm được nhấn
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) return Colors.black; 
                      return Colors.blue; 
                    }),  
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    elevation: MaterialStateProperty.all(5), 
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                    ),
                  ),
                  child: Text(
                    "Tiếp tục",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
