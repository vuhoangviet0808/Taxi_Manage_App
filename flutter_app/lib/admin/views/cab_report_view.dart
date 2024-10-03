import 'package:flutter/material.dart';
import 'package:flutter_app/admin/viewmodels/cab_viewmodels.dart';
import 'package:flutter_app/admin/models/cab_model.dart';

class CabReportScreenView extends StatefulWidget {
  final List<Cab> cabs;
  final CabDashboardViewModel viewModel;

  const CabReportScreenView({
    Key? key,
    required this.cabs,
    required this.viewModel,
  }) : super(key: key);

  @override
  _CabReportScreenViewState createState() => _CabReportScreenViewState();
}

class _CabReportScreenViewState extends State<CabReportScreenView> {
  String licencePlateFilter = '';
  String idFilter = '';

  @override
  Widget build(BuildContext context) {
    List<Cab> filteredCabs = widget.cabs.where((cab) {
      return cab.licence_plate
              .toLowerCase()
              .contains(licencePlateFilter.toLowerCase()) &&
          cab.ID.contains(idFilter);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin xe', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          _buildSearchSection(),
          _buildCabCount(filteredCabs.length),
          _buildCabTable(filteredCabs),
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
            child: _buildSearchField(
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
            child: _buildSearchField(
              label: 'Tìm kiếm theo biển số xe',
              onChanged: (value) {
                setState(() {
                  licencePlateFilter = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(
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

  Widget _buildCabCount(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Số lượng: $count',
            style: TextStyle(fontSize: 20, color: Colors.teal),
          ),
        ),
      ],
    );
  }

  Widget _buildCabTable(List<Cab> cabs) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 175.0, // Tăng khoảng cách giữa các cột
            headingRowHeight: 56.0, // Tăng chiều cao hàng tiêu đề
            dataRowHeight: 56.0, // Tăng chiều cao hàng dữ liệu
            headingRowColor:
                MaterialStateColor.resolveWith((states) => Colors.teal.shade50),
            columns: [
              DataColumn(
                label: Text(
                  'ID',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.left, // Align to the left
                ),
              ),
              DataColumn(
                label: Text(
                  'Biển số xe',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.right, // Align to the right
                ),
              ),
            ],
            rows: cabs.map((cab) {
              return DataRow(cells: [
                DataCell(
                  GestureDetector(
                    onTap: () {
                      widget.viewModel.fetchEachCab(context, cab.ID);
                    },
                    child: Text(
                      cab.ID,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: Colors.teal,
                      ),
                      textAlign: TextAlign.left, // Align to the left
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    cab.licence_plate,
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.right, // Align to the right
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

class CabDetailScreen extends StatelessWidget {
  final FullCab cab;
  final CabDashboardViewModel cabViewModel = CabDashboardViewModel();

  CabDetailScreen({Key? key, required this.cab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double fontSize = 16.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin chi tiết xe'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildDetailText('ID xe: ', cab.ID),
            SizedBox(height: 8),
            _buildDetailText('Biển số xe: ', cab.licence_plate),
            SizedBox(height: 8),
            _buildDetailText('ID model xe: ', cab.car_model_id),
            SizedBox(height: 8),
            _buildDetailText('Năm sản xuất: ', cab.manufacture_year.toString()),
            SizedBox(height: 8),
            _buildDetailText('Hoạt động: ', cab.active.toString()),
            SizedBox(height: 8),
            _buildDetailText('Tên model: ', cab.model_name),
            SizedBox(height: 8),
            _buildDetailText('Mô tả model: ', cab.model_description),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailText(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}