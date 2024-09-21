// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class SMSMessagePage extends StatefulWidget {
  final String phone;

  SMSMessagePage(this.phone);

  @override
  _SMSMessagePageState createState() => _SMSMessagePageState();
}

class _SMSMessagePageState extends State<SMSMessagePage> {
  final List<TextEditingController> _controllers = List.generate(5, (index) => TextEditingController());
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = '';

  void _validateCode() {
    String code = _controllers.map((controller) => controller.text).join('');
    if (code == "11111") {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => NextPage()),
      // );
    } else {
      setState(() {
        _errorMessage = 'Mã nhập không đúng. Vui lòng thử lại.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xff3277D8)),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Text(
                  "Nhập mã",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  "Chúng tôi đã gửi một SMS chứa mã kích hoạt đến số điện thoại ",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
              if (_errorMessage.isNotEmpty) ...[
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 8),
              ],
              Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) => _buildNumberField(_controllers[index])),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _validateCode,
                child: Text('Xác nhận'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(TextEditingController controller) {
    return Container(
      width: 50,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
          counterText: '', // Remove the counter
        ),
        maxLength: 1,
      ),
    );
  }
}