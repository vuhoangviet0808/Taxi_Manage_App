import 'package:flutter/material.dart';
import 'package:flutter_app/driver/src/viewmodels/driver_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/driver.dart';
import '../services/driver_info_services.dart';

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
  late TextEditingController _cccdController;
  late TextEditingController _addressController;
  late TextEditingController _licenseController;
  String _gender = '';
  List<CabRide> _cabRides = [];
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    fetchCabRides();
    _firstNameController = TextEditingController(text: widget.driver.firstname);
    _lastNameController = TextEditingController(text: widget.driver.lastname);
    _dobController =
        TextEditingController(text: _formatDate(widget.driver.DOB));
    _gender = widget.driver.gender;
    _cccdController = TextEditingController(text: widget.driver.CCCD);
    _addressController = TextEditingController(text: widget.driver.Address);
    _licenseController =
        TextEditingController(text: widget.driver.Driving_license);
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
    _cccdController.dispose();
    _addressController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final driverViewModel = Provider.of<DriverViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Thông tin tài xế",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: "Roboto",
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              "Lưu",
              style: TextStyle(
                  fontSize: 14, fontFamily: "Roboto", color: Colors.redAccent),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                var updateDriver = Driver(
                  Driver_ID: widget.driver.Driver_ID,
                  firstname: _firstNameController.text,
                  lastname: _lastNameController.text,
                  SDT: widget.driver.SDT,
                  Wallet: _totalPrice, // cập nhật từ _totalPrice
                  DOB: _dobController.text.isEmpty
                      ? widget.driver.DOB
                      : _dobController.text,
                  gender: _gender,
                  CCCD: _cccdController.text,
                  Address: _addressController.text,
                  Driving_license: _licenseController.text,
                  Working_experiment: widget.driver.Working_experiment,
                );

                driverViewModel.updateDriverInfo(updateDriver).then((_) {
                  setState(() {
                    widget.driver.firstname = _firstNameController.text;
                    widget.driver.lastname = _lastNameController.text;
                    widget.driver.DOB = _dobController.text;
                    widget.driver.gender = _gender;
                    widget.driver.CCCD = _cccdController.text;
                    widget.driver.Address = _addressController.text;
                    widget.driver.Driving_license = _licenseController.text;
                    widget.driver.Wallet =
                        _totalPrice; // cập nhật từ _totalPrice
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Thông tin tài xế đã được cập nhật!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                });
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/driver/anhthe.jpg'),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _lastNameController,
                    label: "Họ",
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập họ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _firstNameController,
                    label: "Tên",
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    label: "SĐT: ${widget.driver.SDT}",
                    icon: Icons.phone,
                    enabled: false,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _dobController,
                    label: "Ngày sinh",
                    icon: Icons.calendar_today,
                    hintText: "YYYY-MM-DD",
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập ngày sinh';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _buildGenderDropdown(),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField(
                          controller: _cccdController,
                          label: "CCCD",
                          icon: Icons.credit_card,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập CCCD';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _addressController,
                    label: "Địa chỉ",
                    icon: Icons.home,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập địa chỉ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _licenseController,
                    label: "Số giấy phép lái xe",
                    icon: Icons.drive_eta,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập số giấy phép lái xe';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    required String label,
    required IconData icon,
    String? hintText,
    bool readOnly = false,
    bool enabled = true,
    String? Function(String?)? validator,
    void Function()? onTap,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon),
        labelStyle: TextStyle(color: Colors.black, fontSize: 16),
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
          borderSide: BorderSide(color: Colors.white, width: 0.5),
        ),
      ),
      enabled: enabled,
      readOnly: readOnly,
      validator: validator,
      onTap: onTap,
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _gender,
      decoration: InputDecoration(
        labelText: 'Giới tính',
        prefixIcon: Icon(Icons.wc),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      items: ['Nam', 'Nữ'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _gender = newValue!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng chọn giới tính';
        }
        return null;
      },
    );
  }

  void fetchCabRides() async {
    CabRideInfoService cabRides = CabRideInfoService();
    List<CabRide> rides = await cabRides.getCabRide(widget.driver.Driver_ID);
    setState(() {
      _cabRides = rides;
      _totalPrice = _cabRides.fold(0, (sum, ride) => sum + ride.price);
    });
  }
}
