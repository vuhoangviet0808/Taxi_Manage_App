// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../viewmodels/account_input_infor_view_model.dart';
import 'package:provider/provider.dart';
import '../../user/user_main.dart';

class CCCDInputPage extends StatefulWidget {
  final String phoneNumber;
  final String firstname;
  final String lastname;
  final String sex;
  final String dob;

  CCCDInputPage({
    required this.phoneNumber,
    required this.firstname,
    required this.lastname,
    required this.sex,
    required this.dob,
  });

  @override
  _CCDDInputPageState createState() => _CCDDInputPageState();
}

class _CCDDInputPageState extends State<CCCDInputPage> {
  final TextEditingController cccdController = TextEditingController();
  String _cccdError = "";
  
  @override
  Widget build(BuildContext context) {
    final view = Provider.of<AccountInputInforViewModel>(context);

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
              "Nhập số CCCD:",
              style: TextStyle(
                fontSize: 16,
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            if(_cccdError.isNotEmpty) Text (
              _cccdError,
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: cccdController,
              // onChanged: (value) {
              //   setState(() {
              //     if (value.isEmpty) {
              //       _cccdError = "Vui lòng nhập số CCCD của bạn";
              //     } else if (value.length != 10 || !value.contains(RegExp(r'^[0-9]+$'))) {
              //       _cccdError = "Số CCCD không hợp lệ";
              //     } else {
              //       _cccdError = "";
              //     }
              //   });
              // },
              decoration: InputDecoration(
                labelText: "Số CCCD",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffCED0D2), width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String cccd = cccdController.text.trim();
                if (cccd.isEmpty) {
                  setState(() {
                    _cccdError = "Vui lòng nhập số CCCD của bạn";
                  });
                } else if (cccd.length != 10 || !cccd.contains(RegExp(r'^[0-9]+$'))) {
                  setState(() {
                    _cccdError = "Số CCCD không hợp lệ";
                  });
                } else {
                  if(!view.isLoading) {
                    cccd = '${cccd.substring(0,3)}-${cccd.substring(3,6)}-${cccd.substring(6)}';
                    bool success = await view.inputinfor(widget.phoneNumber, widget.firstname, widget.lastname, widget.sex, widget.dob, cccd);
                    
                    if(!success) {
                      _showDialog(context,false, view.errorMessage, widget.phoneNumber);
                    } else {
                      _showDialog(context,true, "Input Infor success", widget.phoneNumber);
                    }
                  }
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

void _showDialog(BuildContext context, bool success, String message, String sdt) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: success ? Text("") : Text("Error"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
                if (success) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserPage(sdt: sdt,)),
                );
              }
            },
          ),
        ],
      );
    },
  );
}
