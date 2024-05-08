import 'package:flutter/material.dart';
import 'package:flutter_app/driver/viewmodels/driver_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../models/driver.dart';

class DriverInfor extends StatefulWidget {
  final Driver driver;
  DriverInfor({required this.driver});
  @override
  State<DriverInfor> createState() => _DriverInforState();
}

class _DriverInforState extends State<DriverInfor> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _cccdController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _licenseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.driver.firstname);
    _lastNameController = TextEditingController(text: widget.driver.lastname);
    _phoneController = TextEditingController(text: widget.driver.SDT);
    _dobController = TextEditingController(text: widget.driver.DOB);
    _genderController = TextEditingController(text: widget.driver.gender);
    _cccdController = TextEditingController(text: widget.driver.CCCD);
    _addressController = TextEditingController(text: widget.driver.Address);
    _licenseController =
        TextEditingController(text: widget.driver.Driving_license);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _cccdController.dispose();
    _addressController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final driverViewModel = Provider.of<DriverViewModel>(context);
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
                      "Thông tin tài xế",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Roboto"),
                    ),
                    actions: [
                      TextButton(
                        child: Text(
                          "Lưu",
                          style: TextStyle(fontSize: 14, fontFamily: "Roboto"),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            var updateDriver = Driver(
                                Driver_ID: widget.driver.Driver_ID,
                                firstname: _firstNameController.text,
                                lastname: _lastNameController.text,
                                SDT: widget.driver.SDT,
                                Wallet: widget.driver.Wallet,
                                DOB: _dobController.text,
                                gender: _genderController.text,
                                CCCD: _cccdController.text,
                                Address: _addressController.text,
                                Driving_license: _licenseController.text,
                                Working_experiment:
                                    widget.driver.Working_experiment);
                            driverViewModel.updateDriverInfo(updateDriver);
                          }
                        },
                      ),
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
                              labelText:
                                  "First Name: ${widget.driver.firstname}",
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.grey), // Màu của viền khi focus
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .grey), // Màu của viền khi chưa focus
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.red), // Màu của viền khi có lỗi
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 0.5))),
                        ),
                      ),
                      SizedBox(
                        width: 206.4,
                        height: 60,
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                              labelText: "Last Name: ${widget.driver.lastname}",
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.grey), // Màu của viền khi focus
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .grey), // Màu của viền khi chưa focus
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.red), // Màu của viền khi có lỗi
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 0.5))),
                        ),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                          labelText: "SĐT: ${widget.driver.SDT}",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey), // Màu của viền khi focus
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Colors.grey), // Màu của viền khi chưa focus
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red), // Màu của viền khi có lỗi
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.5))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: TextFormField(
                      controller: _dobController,
                      decoration: InputDecoration(
                          labelText: "DOB: ${widget.driver.DOB}",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey), // Màu của viền khi focus
                          ),
                          hintText: "YYYY-MM-DD",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Colors.grey), // Màu của viền khi chưa focus
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red), // Màu của viền khi có lỗi
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.5))),
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
                          decoration: InputDecoration(
                              labelText: "Sex: ${widget.driver.gender}",
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              hintText: "Nam/Nữ",
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.grey), // Màu của viền khi focus
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .grey), // Màu của viền khi chưa focus
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.red), // Màu của viền khi có lỗi
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 0.5))),
                        ),
                      ),
                      SizedBox(
                        width: 291.4,
                        height: 60,
                        child: TextFormField(
                          controller: _cccdController,
                          decoration: InputDecoration(
                              labelText: "CCCD: ${widget.driver.CCCD}",
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.grey), // Màu của viền khi focus
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .grey), // Màu của viền khi chưa focus
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.red), // Màu của viền khi có lỗi
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 0.5))),
                        ),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                          labelText: "Address: ${widget.driver.Address}",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey), // Màu của viền khi focus
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Colors.grey), // Màu của viền khi chưa focus
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red), // Màu của viền khi có lỗi
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.5))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: TextFormField(
                      controller: _licenseController,
                      decoration: InputDecoration(
                          labelText:
                              "Driver's License Number: ${widget.driver.Driving_license}",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey), // Màu của viền khi focus
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Colors.grey), // Màu của viền khi chưa focus
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red), // Màu của viền khi có lỗi
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.5))),
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
