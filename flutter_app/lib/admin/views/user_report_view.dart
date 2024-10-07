// ignore_for_file: unnecessary_string_interpolations, library_private_types_in_public_api, prefer_const_declarations

import 'package:flutter/material.dart';
import 'package:flutter_app/admin/viewmodels/user_viewmodels.dart';
import 'package:flutter_app/admin/models/user_model.dart';

class UserReportScreenView extends StatefulWidget {
  final List<User> users;
  final UserDashboardViewModel viewModel;

  const UserReportScreenView({
    Key? key,
    required this.users,
    required this.viewModel,
  }) : super(key: key);

  @override
  _UserReportScreenViewState createState() => _UserReportScreenViewState();
}

class _UserReportScreenViewState extends State<UserReportScreenView> {
  String nameFilter = '';
  String idFilter = '';

  @override
  Widget build(BuildContext context) {
    List<User> filteredUsers = widget.users.where((user) {
      return (user.Firstname.toLowerCase().contains(nameFilter.toLowerCase()) ||
              user.Lastname.toLowerCase().contains(nameFilter.toLowerCase())) &&
          user.User_ID.contains(idFilter);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('User Information', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        color: Color.fromARGB(255, 203, 235, 231), // Thêm màu nền ở đây
        child: Column(
          children: [
            _buildSearchSection(),
            _buildUserCount(filteredUsers.length),
            Expanded(
              child: Container(
                color: Colors.white, // Màu nền trắng cho bảng thông tin
                child: _buildUserTable(filteredUsers),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text("Filter"),
        leading: Icon(Icons.search, color: Colors.teal),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSoftSearchField(
              label: 'By ID',
              onChanged: (value) {
                setState(() {
                  idFilter = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSoftSearchField(
              label: 'By Name',
              onChanged: (value) {
                setState(() {
                  nameFilter = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoftSearchField(
      {required String label, required Function(String) onChanged}) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.search, color: Colors.teal),
        filled: true,
        fillColor: Colors.teal.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.teal),
        ),
      ),
    );
  }

  Widget _buildUserCount(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Quantity: $count',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildUserTable(List<User> users) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 60.0,
            headingRowHeight: 56.0,
            dataRowHeight: 56.0,
            headingRowColor: MaterialStateColor.resolveWith(
                (states) => Colors.teal.shade100),
            columns: [
              DataColumn(
                label: Text(
                  'ID',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              DataColumn(
                label: Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              DataColumn(
                label: Text(
                  'Avatar',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
            rows: users.map((user) {
              return DataRow(cells: [
                DataCell(
                  GestureDetector(
                    onTap: () {
                      widget.viewModel.fetchEachUser(context, user.User_ID);
                    },
                    child: Text(
                      user.User_ID,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    "${user.Firstname} ${user.Lastname}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/admin/adminDefault.jpg'),
                        radius: 20,
                      ),
                    ],
                  ),
                ),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class UserDetailScreen extends StatelessWidget {
  final FullUser user;

  const UserDetailScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double fontSize = 16.0;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 203, 235, 231),
      appBar: AppBar(
        title:
            Text('Detailed Information', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/admin/adminDefault.jpg'),
                      radius: 60,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${user.Firstname} ${user.Lastname}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Màu nền cho Container
                borderRadius: BorderRadius.circular(10),
              ),
              padding:
                  EdgeInsets.only(bottom: 10, top: 20, left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('ID: ', user.User_ID, fontSize),
                  SizedBox(height: 7),
                  _buildDetailRow('Phone number: ', user.SDT, fontSize),
                  SizedBox(height: 7),
                  _buildDetailRow('Wallet: ', user.Wallet, fontSize),
                  SizedBox(height: 7),
                  _buildDetailRow('DOB: ', user.DOB, fontSize),
                  SizedBox(height: 7),
                  _buildDetailRow('Gender: ', user.Gender, fontSize),
                  SizedBox(height: 7),
                  _buildDetailRow('Address: ', user.Address, fontSize),
                  SizedBox(height: 7),
                  _buildDetailRow('Identity Card: ', user.CCCD, fontSize),
                  SizedBox(height: 7),
                  _buildDetailRow(
                      'Account Creation:', user.created_at, fontSize),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, double fontSize) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: fontSize,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                color: Colors.black,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
