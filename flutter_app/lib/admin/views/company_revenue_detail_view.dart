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
        title: Text('Doanh thu công ty chi tiết'),
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () async {
                  final pickedDate = await _selectDate(context, startDate);
                  if (pickedDate != null) {
                    setState(() {
                      startDate = pickedDate;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: startDate != null
                          ? DateFormat('dd-MM-yyyy').format(startDate!)
                          : 'Ngày bắt đầu',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  final pickedDate = await _selectDate(context, endDate);
                  if (pickedDate != null) {
                    setState(() {
                      endDate = pickedDate;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: endDate != null
                          ? DateFormat('dd-MM-yyyy').format(endDate!)
                          : 'Ngày kết thúc',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (startDate != null && endDate != null) {
                    _fetchCompanyRevenue();
                  } else {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Vui lòng chọn ngày bắt đầu và ngày kết thúc.'),
                      ),
                    );
                  }
                },
                child: Text('Xem báo cáo'),
              ),
              SizedBox(height: 20),
              if (isLoading) Center(child: CircularProgressIndicator()),
              if (revenueData.isNotEmpty)
                Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics:
                          NeverScrollableScrollPhysics(), // Disable inner ListView scrolling
                      itemCount: revenueData.length,
                      itemBuilder: (context, index) {
                        final revenueItem = revenueData[index];
                        return ListTile(
                          title: Text(revenueItem['period']),
                          subtitle:
                              Text('Doanh thu: ${revenueItem['revenue']}'),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 300,
                      padding: EdgeInsets.all(16),
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: _calculateMaxRevenue(),
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: SideTitles(
                              showTitles: true,
                              getTextStyles: (context, value) =>
                                  const TextStyle(
                                color: Color(0xff7589a2),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              margin: 20,
                              getTitles: (double value) {
                                // Ensure index is valid within revenueData length
                                int index = value.toInt();
                                if (index >= 0 && index < revenueData.length) {
                                  String period = revenueData[
                                      revenueData.length - 1 - index]['period'];
                                  List<String> parts = period.split('-');
                                  if (parts.length >= 2) {
                                    return parts[1]; // Return month part only
                                  }
                                }
                                return '';
                              },
                            ),
                            leftTitles: SideTitles(
                              showTitles: false, // Disable left side titles
                            ),
                            topTitles: SideTitles(
                              showTitles: false, // Disable top side titles
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            checkToShowHorizontalLine: (value) =>
                                value % 10 == 0,
                            getDrawingHorizontalLine: (value) => FlLine(
                                color: const Color(0xff37434d), strokeWidth: 1),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                                color: const Color(0xff37434d), width: 1),
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
                ),
            ],
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
      // Handle error
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
