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
        title:
            Text('Thông tin người dùng', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          _buildSearchSection(),
          _buildUserCount(filteredUsers.length),
          _buildUserTable(filteredUsers),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text("Tìm kiếm"),
        leading: Icon(Icons.search, color: Colors.teal),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSoftSearchField(
              label: 'Tìm kiếm theo ID',
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
              label: 'Tìm kiếm theo tên',
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
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Số lượng: $count',
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
            columnSpacing: 24.0,
            headingRowHeight: 56.0,
            dataRowHeight: 56.0,
            headingRowColor:
                MaterialStateColor.resolveWith((states) => Colors.teal.shade50),
            columns: [
              DataColumn(
                label: Text(
                  'ID',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              DataColumn(
                label: Text(
                  'Họ tên',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              DataColumn(
                label: Text(
                  'Hình ảnh',
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
                        // backgroundImage: NetworkImage(user.profileImageUrl ?? 'https://via.placeholder.com/150'),
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
      appBar: AppBar(
        title: Text('Thông tin chi tiết người dùng'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildDetailRow('ID người dùng:', user.User_ID, fontSize),
            _buildDetailRow(
                'Họ và tên:', '${user.Firstname} ${user.Lastname}', fontSize),
            _buildDetailRow('Số điện thoại:', user.SDT, fontSize),
            _buildDetailRow('Ví:', user.Wallet, fontSize),
            _buildDetailRow('Ngày sinh:', user.DOB, fontSize),
            _buildDetailRow('Giới tính:', user.Gender, fontSize),
            _buildDetailRow('Địa chỉ:', user.Address, fontSize),
            _buildDetailRow('CCCD:', user.CCCD, fontSize),
            _buildDetailRow('Ngày tạo:', user.created_at, fontSize),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, double fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label ',
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
