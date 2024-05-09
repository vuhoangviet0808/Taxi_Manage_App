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

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _dobController;
  late TextEditingController _genderController;
  late TextEditingController _cccdController;
  late TextEditingController _addressController;
  late TextEditingController _licenseController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.driver.firstname);
    _lastNameController = TextEditingController(text: widget.driver.lastname);
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

                            driverViewModel
                                .updateDriverInfo(updateDriver)
                                .then((_) {
                              setState(() {
                                widget.driver.firstname =
                                    _firstNameController.text;
                                widget.driver.lastname =
                                    _lastNameController.text;
                                widget.driver.DOB = _dobController.text;
                                widget.driver.gender = _genderController.text;
                                widget.driver.CCCD = _cccdController.text;
                                widget.driver.Address = _addressController.text;
                                widget.driver.Driving_license =
                                    _licenseController.text;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Thông tin tài xế đã được cập nhật!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            });
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
                              labelText: "First Name",
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
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
                              labelText: "Last Name",
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
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
                      decoration: InputDecoration(
                          labelText: "SĐT:${widget.driver.SDT}",
                          hintText: "Cannot Change Phone Number",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
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
                          labelText: "DOB",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                          hintText: "YYYY-MM-DD",
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
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
                              labelText: "Sex",
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              hintText: "Nam/Nữ",
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
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
                              labelText: "CCCD",
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
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
                          labelText: "Address",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
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
                          labelText: "Driver's License Number",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
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
