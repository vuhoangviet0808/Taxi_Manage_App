// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sized_box_for_whitespace

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../viewmodels/account_login_view_model.dart';


class LoginPage extends StatefulWidget {

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AccountLoginViewModel>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (viewModel.isLoading)
                CircularProgressIndicator(), 
              SizedBox(height: 100),
              Image(image: AssetImage('assets/icontaxi.png'), width: 200, height: 60, ),
              Padding(
                padding: EdgeInsets.only(top: 40, bottom: 6),
                child: Text(
                  "Taxi Driver",
                  style: TextStyle(fontSize: 22, color: Colors.black.withOpacity(0.7)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 100),
                child: Text(
                  "Login to continue",
                  style: TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.5)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: TextField(
                  controller: _usernameController,
                  style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 18),
                  decoration: InputDecoration(
                    labelText: "Username",
                    prefixIcon: Container(
                      width: 50,
                      child: Icon(Icons.person, color: Colors.grey.withOpacity(0.6),),
                    ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black.withOpacity(0.2), width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  ),
                ),
              ),
              TextField(
                controller: _passwordController,
                style: TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Container(
                    width: 50,
                    child: Icon(Icons.lock, color: Colors.grey.withOpacity(0.6)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide: BorderSide(color: Colors.black.withOpacity(0.2), width: 1),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: viewModel.isLoading ? null : () async {
                  bool success = await viewModel.login(_usernameController.text, _passwordController.text);
                  if(!success) {
                    _showDialog(context, viewModel.errorMessage);
                  } else {
                    _showDialog(context, "Successfully!");
                  }
                },
                child: Text("Login"),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  constraints: BoxConstraints.loose(Size(double.infinity, 40)),
                  child: Text(
                    "Forgot My Password",
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}