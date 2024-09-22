// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:fl_chart/fl_chart.dart';

// class CompanyRevenueDetailScreen extends StatefulWidget {
//   const CompanyRevenueDetailScreen({Key? key}) : super(key: key);

//   @override
//   _CompanyRevenueDetailScreenState createState() =>
//       _CompanyRevenueDetailScreenState();
// }

// class _CompanyRevenueDetailScreenState
//     extends State<CompanyRevenueDetailScreen> {
//   DateTime? startDate;
//   DateTime? endDate;
//   List<dynamic> revenueData = [];
//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Doanh thu công ty chi tiết',
//             style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.teal, // Matching color
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildDateField('Ngày bắt đầu', startDate, (pickedDate) {
//               setState(() {
//                 startDate = pickedDate;
//               });
//             }),
//             SizedBox(height: 16),
//             _buildDateField('Ngày kết thúc', endDate, (pickedDate) {
//               setState(() {
//                 endDate = pickedDate;
//               });
//             }),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 if (startDate != null && endDate != null) {
//                   _fetchCompanyRevenue();
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content:
//                           Text('Vui lòng chọn ngày bắt đầu và ngày kết thúc.'),
//                     ),
//                   );
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal, // Matching color
//                 padding: EdgeInsets.symmetric(vertical: 16),
//               ),
//               child: Text('Xem báo cáo',
//                   style: TextStyle(fontSize: 16, color: Colors.white)),
//             ),
//             SizedBox(height: 24),
//             if (isLoading) Center(child: CircularProgressIndicator()),
//             if (revenueData.isNotEmpty)
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: revenueData.length,
//                         itemBuilder: (context, index) {
//                           final revenueItem = revenueData[index];
//                           return Card(
//                             margin: EdgeInsets.symmetric(vertical: 8),
//                             elevation: 4,
//                             child: ListTile(
//                               title: Text(revenueItem['period']),
//                               subtitle:
//                                   Text('Doanh thu: ${revenueItem['revenue']}'),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 24),
//                     Container(
//                       height: 300,
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white, // Matching color
//                         borderRadius: BorderRadius.circular(8),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.2),
//                             spreadRadius: 2,
//                             blurRadius: 4,
//                             offset: Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: BarChart(
//                         BarChartData(
//                           alignment: BarChartAlignment.spaceAround,
//                           maxY: _calculateMaxRevenue(),
//                           barTouchData: BarTouchData(enabled: false),
//                           titlesData: FlTitlesData(
//                             show: true,
//                             bottomTitles: SideTitles(
//                               showTitles: true,
//                               getTextStyles: (context, value) => TextStyle(
//                                 color: Color(0xff7589a2),
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14,
//                               ),
//                               margin: 20,
//                               getTitles: (double value) {
//                                 int index = value.toInt();
//                                 if (index >= 0 && index < revenueData.length) {
//                                   String period = revenueData[
//                                       revenueData.length - 1 - index]['period'];
//                                   List<String> parts = period.split('-');
//                                   if (parts.length >= 2) {
//                                     return parts[1]; // Return month part only
//                                   }
//                                 }
//                                 return '';
//                               },
//                             ),
//                             leftTitles: SideTitles(
//                               showTitles: false,
//                             ),
//                             topTitles: SideTitles(
//                               showTitles: false,
//                             ),
//                           ),
//                           gridData: FlGridData(
//                             show: true,
//                             checkToShowHorizontalLine: (value) =>
//                                 value % 10 == 0,
//                             getDrawingHorizontalLine: (value) => FlLine(
//                                 color: Color(0xff37434d), strokeWidth: 1),
//                           ),
//                           borderData: FlBorderData(
//                             show: true,
//                             border:
//                                 Border.all(color: Color(0xff37434d), width: 1),
//                           ),
//                           barGroups: List.generate(
//                             revenueData.length,
//                             (index) => BarChartGroupData(
//                               x: index,
//                               barRods: [
//                                 BarChartRodData(
//                                   y: revenueData[revenueData.length - 1 - index]
//                                           ['revenue']
//                                       .toDouble(),
//                                   colors: [Colors.blue],
//                                   width: 16,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDateField(
//       String label, DateTime? date, Function(DateTime?) onDatePicked) {
//     return GestureDetector(
//       onTap: () async {
//         final pickedDate = await _selectDate(context, date);
//         if (pickedDate != null) {
//           onDatePicked(pickedDate);
//         }
//       },
//       child: AbsorbPointer(
//         child: TextField(
//           decoration: InputDecoration(
//             labelText:
//                 date != null ? DateFormat('dd-MM-yyyy').format(date) : label,
//             prefixIcon: Icon(Icons.calendar_today),
//             border: OutlineInputBorder(),
//             contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//           ),
//         ),
//       ),
//     );
//   }

//   double _calculateMaxRevenue() {
//     double maxRevenue = 0;
//     for (var data in revenueData) {
//       double revenue = data['revenue'];
//       if (revenue > maxRevenue) {
//         maxRevenue = revenue;
//       }
//     }
//     return maxRevenue + (maxRevenue * 0.2); // Add some padding to top of chart
//   }

//   Future<DateTime?> _selectDate(
//       BuildContext context, DateTime? initialDate) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: initialDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     return pickedDate;
//   }

//   Future<void> _fetchCompanyRevenue() async {
//     setState(() {
//       isLoading = true;
//     });

//     final response = await http.get(
//       Uri.parse(
//           'http://10.0.2.2:5000/admin/company_revenue?start_date=${DateFormat('dd-MM-yyyy').format(startDate!)}&end_date=${DateFormat('dd-MM-yyyy').format(endDate!)}'),
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         revenueData = json.decode(response.body)['revenue_data'];
//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Đã xảy ra lỗi khi tải dữ liệu.'),
//         ),
//       );
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class CompanyRevenueDetailScreen extends StatefulWidget {
  const CompanyRevenueDetailScreen({Key? key}) : super(key: key);

  @override
  _CompanyRevenueDetailScreenState createState() =>
      _CompanyRevenueDetailScreenState();
}

class _CompanyRevenueDetailScreenState
    extends State<CompanyRevenueDetailScreen> {
  DateTime? startDate;
  DateTime? endDate;
  List<dynamic> revenueData = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doanh thu công ty chi tiết',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal, // Matching color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDateField('Ngày bắt đầu', startDate, (pickedDate) {
              setState(() {
                startDate = pickedDate;
              });
            }),
            SizedBox(height: 16),
            _buildDateField('Ngày kết thúc', endDate, (pickedDate) {
              setState(() {
                endDate = pickedDate;
              });
            }),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (startDate != null && endDate != null) {
                  _fetchCompanyRevenue();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Vui lòng chọn ngày bắt đầu và ngày kết thúc.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Matching color
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Xem báo cáo',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            SizedBox(height: 24),
            if (isLoading) Center(child: CircularProgressIndicator()),
            if (revenueData.isNotEmpty) ...[
              Container(
                height: 300, // Fixed height for the ListView
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: revenueData.length,
                  itemBuilder: (context, index) {
                    final revenueItem = revenueData[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      child: ListTile(
                        title: Text(revenueItem['period']),
                        subtitle: Text('Doanh thu: ${revenueItem['revenue']}'),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24),
              Container(
                height: 300,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: _calculateMaxRevenue(),
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (context, value) => TextStyle(
                          color: Color(0xff7589a2),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        margin: 20,
                        getTitles: (double value) {
                          int index = value.toInt();
                          if (index >= 0 && index < revenueData.length) {
                            String period =
                                revenueData[revenueData.length - 1 - index]
                                    ['period'];
                            List<String> parts = period.split('-');
                            if (parts.length >= 2) {
                              return parts[1]; // Return month part only
                            }
                          }
                          return '';
                        },
                      ),
                      leftTitles: SideTitles(
                        showTitles: false,
                      ),
                      topTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      checkToShowHorizontalLine: (value) => value % 10 == 0,
                      getDrawingHorizontalLine: (value) =>
                          FlLine(color: Color(0xff37434d), strokeWidth: 1),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Color(0xff37434d), width: 1),
                    ),
                    barGroups: List.generate(
                      revenueData.length,
                      (index) => BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            y: revenueData[revenueData.length - 1 - index]
                                    ['revenue']
                                .toDouble(),
                            colors: [Colors.blue],
                            width: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(
      String label, DateTime? date, Function(DateTime?) onDatePicked) {
    return GestureDetector(
      onTap: () async {
        final pickedDate = await _selectDate(context, date);
        if (pickedDate != null) {
          onDatePicked(pickedDate);
        }
      },
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
            labelText:
                date != null ? DateFormat('dd-MM-yyyy').format(date) : label,
            prefixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          ),
        ),
      ),
    );
  }

  double _calculateMaxRevenue() {
    double maxRevenue = 0;
    for (var data in revenueData) {
      double revenue = data['revenue'];
      if (revenue > maxRevenue) {
        maxRevenue = revenue;
      }
    }
    return maxRevenue + (maxRevenue * 0.2); // Add some padding to top of chart
  }

  Future<DateTime?> _selectDate(
      BuildContext context, DateTime? initialDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    return pickedDate;
  }

  Future<void> _fetchCompanyRevenue() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse(
          'http://10.0.2.2:5000/admin/company_revenue?start_date=${DateFormat('dd-MM-yyyy').format(startDate!)}&end_date=${DateFormat('dd-MM-yyyy').format(endDate!)}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        revenueData = json.decode(response.body)['revenue_data'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi khi tải dữ liệu.'),
        ),
      );
    }
  }
}
