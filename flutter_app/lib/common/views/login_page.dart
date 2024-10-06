// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter_app/common/viewmodels/account_register_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../viewmodels/account_login_view_model.dart';
import '../../../../user/user_main.dart';
import '../../../../admin/admin_main.dart';
import '../../../../driver/driver_main.dart';
import 'register_views/register_page.dart';
import './forgot_password_views/forgot_page.dart';

class LoginPage extends StatefulWidget {

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _sdtController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Color _textColor = Colors.grey.shade700;
  Color _backgroundColor = Colors.grey.shade700;

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
              Image(image: AssetImage('assets/common/icontaxi.png'), width: 200, height: 60, ),
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
                  "Đăng nhập để tiếp tục",
                  style: TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.5)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: TextField(
                  controller: _sdtController,
                  style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 18),
                  decoration: InputDecoration(
                    labelText: "Số di động",
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
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget> [
                  ElevatedButton(
                    onPressed: viewModel.isLoading ? null : () async {
                      bool success = await viewModel.login(_sdtController.text, _passwordController.text);
                      if(!success) {
                        // ignore: use_build_context_synchronously
                        _showDialog(context, viewModel.errorMessage);
                      } else {
                        switch(viewModel.role) {
                          // case "admin":
                          //   Navigator.push(context,
                          // MaterialPageRoute(builder: (context) => AdminPage()));
                            // break;
                          case "driver":
                            Navigator.push(context,
                          MaterialPageRoute(builder: (context) => DriverPage(sdt: viewModel.sdt)));
                            break;
                          case "user":
                            Navigator.push(context,
                          MaterialPageRoute(builder: (context) => UserPage(sdt: viewModel.sdt)));
                            break;
                          default:
                            _showDialog(context, "Access Denied");
                            break;
                        }
                      }
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
                    child: Text("Đăng nhập"),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(
                          builder:(context) => ChangeNotifierProvider(
                            create: (context) => AccountRegisterViewModel(),
                            child: RegisterPage(),
                          ),
                        ),
                      );
                    },
                    onHighlightChanged: (value) {
                      setState(() {
                        if (value) {
                          _textColor = Colors.red; 
                        } else {
                          _textColor = Colors.grey.shade700; 
                        }
                      });
                    },
                    child: Text(
                      "Tạo tài khoản mới",
                      style: TextStyle(
                        color: _textColor, // Màu ban đầu
                        decoration: TextDecoration.underline, // Thêm gạch chân để giống liên kết
                      ),
                    ),
                  ),
                ]
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  constraints: BoxConstraints.loose(Size(double.infinity, 40)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder:(context) => ForgotPasswordPage()));
                    },
                    onHighlightChanged: (value) {
                      setState(() {
                        if (value) {
                          _backgroundColor = Colors.red; // Thay đổi sang màu đỏ khi nhấn
                        } else {
                          _backgroundColor = Colors.grey.shade700; // Trở lại màu ban đầu khi không nhấn nữa
                        }
                      });
                    },
                    child: Text(
                      "Bạn quên mật khẩu ư?",
                      style: TextStyle(
                        color: _backgroundColor, // Màu ban đầu
                        decoration: TextDecoration.underline, // Thêm gạch chân để giống liên kết
                      ),
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
