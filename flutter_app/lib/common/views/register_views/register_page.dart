// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../login_page.dart';
import '../../viewmodels/account_register_view_model.dart';
import 'nameinput_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _sdtController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _phoneError = "";

  @override
  Widget build(BuildContext context) {
    final view = Provider.of<AccountRegisterViewModel>(context);

    bool checkPhone(String phone) {
      if(phone.length != 10) return false;
      return RegExp(r'^[0-9]+$').hasMatch(phone);
    }

    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.white,
         iconTheme: IconThemeData(color: Color(0xff3277D8)),
         elevation: 0,
       ),
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 80),
              Image(image: AssetImage('assets/common/icontaxi.png'), width: 200, height: 60, ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 6),
                child: Text(
                  "Welcome Abroad!",
                  style: TextStyle(fontSize: 22, color: Color(0xff333333)),
                ),
              ),
              if(_phoneError.isNotEmpty) Text(
                _phoneError,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
              TextField(
                  controller: _sdtController,
                  style: TextStyle(fontSize: 18,color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Phone number",
                    prefixIcon: SizedBox(
                        width: 50, child: Image.asset("assets/user/phone.png")),
                        border: OutlineInputBorder(
                          borderSide: 
                          BorderSide(color: Color(0xffCED0D2), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
                SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                  style: TextStyle(fontSize: 18,color: Colors.black),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: SizedBox(
                        width: 50, child: Image.asset("assets/user/lock.png")),
                        border: OutlineInputBorder(
                          borderSide: 
                          BorderSide(color: Color(0xffCED0D2), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 40),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    String sdt = _sdtController.text, password = _passwordController.text;
                    bool hasError = false;

                    if(sdt.isEmpty) {
                      setState(() {
                        _phoneError = "Phone number is required"; 
                      });
                      hasError = true;
                    } else if(!checkPhone(sdt)) {
                      setState(() {
                        _phoneError = "Phone is invalid"; 
                      });
                      hasError = true;
                    } else if(password.isEmpty){
                      setState(() {
                        _phoneError = "Password is required";
                      });
                      hasError = true;
                    } else if(password.length < 6) {
                      setState(() { 
                      _phoneError = "Password must be at least 6 characters";
                      });
                      hasError = true;
                    }
                    if(!hasError && !view.isLoading) {
                        bool success = await view.register(sdt, password);
                        if(!success) {
                          _showDialog(context,false, view.errorMessage);
                        } else {
                          _showDialog(context,true, "Register success");
                        }
                    }

                   
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue.shade300),
                    foregroundColor: MaterialStateProperty.all(Color(0xff3277D8)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                    ),
                  ),
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.white,
                       fontSize: 18
                       ),
                  ), 
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: RichText(
                text: TextSpan(
                  text: "Already a User? ",
                  style: TextStyle(color: Color(0xff606470), fontSize: 16),
                  children: <TextSpan>[
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                      ..onTap = (){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => LoginPage()));
                      },
                      text: "Login now",
                      style: TextStyle(
                        color: Color(0xff3277D8), fontSize: 16))
                  ]),
              ),
            )
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context,bool success, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: success ?  Text(""):Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
                if (success) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NameInputPage(phoneNumber: _sdtController.text,)),
                );
              }
              },
            ),
          ],
        );
      },
    );
  }
}
