// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './CCCDinput_page.dart';
import '../viewmodels/account_input_infor_view_model.dart';

class DOBInputPage extends StatefulWidget {
  final String phoneNumber;
  final String firstname;
  final String lastname;
  final String sex;

  DOBInputPage(
      {required this.phoneNumber,
      required this.firstname,
      required this.lastname,
      required this.sex});

  @override
  _DOBInputPageState createState() => _DOBInputPageState();
}

class _DOBInputPageState extends State<DOBInputPage> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
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
        constraints: BoxConstraints.expand(),
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Ngày sinh của bạn:",
              style: TextStyle(
                fontSize: 16,
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                              create: (context) => AccountInputInforViewModel(),
                              child: CCCDInputPage(
                                phoneNumber: widget.phoneNumber,
                                firstname: widget.firstname,
                                lastname: widget.lastname,
                                sex: widget.sex,
                                dob:
                                    "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                              ),
                            )));
              },
              child: Text("Tiếp tục"),
            ),
          ],
        ),
      ),
    );
  }
}
