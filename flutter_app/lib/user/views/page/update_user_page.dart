import "package:flutter/material.dart";
import 'package:flutter_app/user/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import 'package:intl/intl.dart';

class UpdateUserPage extends StatefulWidget {
  final User user;
  UpdateUserPage({required this.user});

  @override
  State<UpdateUserPage> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _dobController;
  late TextEditingController _genderController;
  late TextEditingController _addressController;
  late TextEditingController _cccdController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstname);
    _lastNameController = TextEditingController(text: widget.user.lastname);
    _dobController = TextEditingController(text: _formatDate(widget.user.DOB));
    _genderController = TextEditingController(text: widget.user.Gender);
    _cccdController = TextEditingController(text: widget.user.CCCD);
    _addressController = TextEditingController(text: widget.user.Address);
  }

  String _formatDate(String date) {
    try {
      final DateTime dateTime = DateTime.parse(date);
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      return formatter.format(dateTime);
    } catch (e) {
      final DateTime dateTime =
          DateFormat('EEE, dd MMM yyyy HH:mm:ss').parse(date, true).toLocal();
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      return formatter.format(dateTime);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _addressController.dispose();
    _cccdController.dispose();
    super.dispose();
  }

  // Hàm kiểm tra hợp lệ cho giới tính
  String? _validateGender(String? value) {
    List<String> validGenders = ['Nam', 'Nữ'];
    if (value == null || !validGenders.contains(value.trim())) {
      return 'Giới tính không hợp lệ. Vui lòng nhập "Nam" hoặc "Nữ".';
    }
    return null; // Không có lỗi
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints.expand(),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppBar(
                    centerTitle: true,
                    title: Text(
                      "User information",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    actions: [
                      TextButton(
                        child: Text(
                          "Save",
                          style: TextStyle(fontSize: 14),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            var updateUser = User(
                              User_ID: widget.user.User_ID,
                              firstname: _firstNameController.text,
                              lastname: _lastNameController.text,
                              SDT: widget.user.SDT,
                              Wallet: widget.user.Wallet,
                              DOB: _dobController.text,
                              Gender: _genderController.text,
                              Address: _addressController.text,
                              CCCD: _cccdController.text,
                              user_token: widget.user.user_token, // Giữ nguyên giá trị user_token
                            );

                            userViewModel.updateUSerInfo(updateUser).then((_) {
                              setState(() {
                                widget.user.firstname = _firstNameController.text;
                                widget.user.lastname = _lastNameController.text;
                                widget.user.DOB = _dobController.text;
                                widget.user.Gender = _genderController.text;
                                widget.user.CCCD = _cccdController.text;
                                widget.user.Address = _addressController.text;
                                // Không thay đổi user_token vì không hiển thị trong form
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Thông tin user đã được cập nhật!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            });
                          }
                        },
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Row(children: <Widget>[
                      SizedBox(
                        width: 205,
                        height: 60,
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: "First name",
                            labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15), // Bo tròn góc
                              borderSide: BorderSide(color: Colors.teal),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15), // Bo tròn góc
                              borderSide: BorderSide(color: Colors.teal),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15), // Bo tròn góc
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15), // Bo tròn góc
                              borderSide: BorderSide(color: Colors.teal, width: 0.5),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 206.4,
                        height: 60,
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: "Last Name",
                            labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15), // Bo tròn góc
                              borderSide: BorderSide(color: Colors.teal),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15), // Bo tròn góc
                              borderSide: BorderSide(color: Colors.teal),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15), // Bo tròn góc
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15), // Bo tròn góc
                              borderSide: BorderSide(color: Colors.teal, width: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "SDT:${widget.user.SDT}",
                        hintText: "Không thể thay đổi SDT",
                        labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15), // Bo tròn góc
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15), // Bo tròn góc
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15), // Bo tròn góc
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15), // Bo tròn góc
                          borderSide: BorderSide(color: Colors.teal, width: 0.5),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: TextFormField(
                      controller: _dobController,
                      decoration: InputDecoration(
                        labelText: "DOB",
                        labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                        hintText: "YYYY-MM-DD",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15), // Bo tròn góc
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15), // Bo tròn góc
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15), // Bo tròn góc
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15), // Bo tròn góc
                          borderSide: BorderSide(color: Colors.teal, width: 0.5),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Row(children: <Widget>[
                      SizedBox(
                        width: 120,
                        height: 60,
                        child: TextFormField(
                          controller: _genderController,
                          validator: _validateGender, // Thêm kiểm tra hợp lệ cho Gender
                          decoration: InputDecoration(
                            labelText: "Sex",
                            labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                            hintText: "Nam/Nữ",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15), // Bo tròn góc
                              borderSide: BorderSide(color: Colors.teal),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15), // Bo tròn góc
                              borderSide: BorderSide(color: Colors.teal),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15), // Bo tròn góc
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15), // Bo tròn góc
                              borderSide: BorderSide(color: Colors.teal, width: 0.5),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 291.4,
                        height: 60,
                        child: TextFormField(
                          controller: _cccdController,
                          decoration: InputDecoration(
                            labelText: 'CCCD',
                            labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15), // Bo tròn góc
                              borderSide: BorderSide(color: Colors.teal),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15), // Bo tròn góc
                              borderSide: BorderSide(color: Colors.teal),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15), // Bo tròn góc
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15), // Bo tròn góc
                              borderSide: BorderSide(color: Colors.teal, width: 0.5),
                            ),
                          ),
                        ),
                      )
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: "Address",
                        labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15), // Bo tròn góc
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        enabledBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(15), // Bo tròn góc
                           borderSide: BorderSide(color: Colors.teal),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

