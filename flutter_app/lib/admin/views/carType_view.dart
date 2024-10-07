import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_app/admin/services/booking_request_services.dart';

class CarTypePieChartView extends StatefulWidget {
  @override
  _CarTypePieChartViewState createState() => _CarTypePieChartViewState();
}

class _CarTypePieChartViewState extends State<CarTypePieChartView> {
  int _4SeatCount = 0;
  int _6SeatCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCarTypeData();
  }

  Future<void> _fetchCarTypeData() async {
    setState(() => _isLoading = true); // Bắt đầu tải dữ liệu
    try {
      BookingRequestService service = BookingRequestService();
      Map<String, int> carTypeCounts = await service.fetchCarTypeCounts();
      setState(() {
        _4SeatCount = carTypeCounts['4_seat'] ?? 0;
        _6SeatCount = carTypeCounts['6_seat'] ?? 0;
      });
    } catch (e) {
      print('Error fetching car type data: $e');
    } finally {
      setState(() => _isLoading = false); // Kết thúc tải dữ liệu
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Trends Details',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: _isLoading ? _buildLoadingIndicator() : _buildPieChart(),
    );
  }

  Center _buildLoadingIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  Padding _buildPieChart() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          _buildLegend(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0, top: 20),
              child: PieChart(
                PieChartData(
                  sections: _getSections(),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 70,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Text(
              'Evaluation of Booking Trends for 4-Seater vs 6-Seater Cars.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(Colors.blueAccent, '4-seat'),
        SizedBox(width: 20), // Khoảng cách giữa các ô chú thích
        _buildLegendItem(Colors.greenAccent, '6-seat'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        SizedBox(width: 5), // Khoảng cách giữa ô màu và nhãn
        Text(label),
      ],
    );
  }

  List<PieChartSectionData> _getSections() {
    int total = _4SeatCount + _6SeatCount;

    if (total == 0) {
      return _noDataSection();
    }

    double _4SeatPercentage = (_4SeatCount / total) * 100;
    double _6SeatPercentage = (_6SeatCount / total) * 100;

    return [
      _createPieChartSection(
        color: Colors.blueAccent,
        value: _4SeatPercentage,
        title: '${_4SeatPercentage.toStringAsFixed(2)}%',
      ),
      _createPieChartSection(
        color: Colors.greenAccent,
        value: _6SeatPercentage,
        title: '${_6SeatPercentage.toStringAsFixed(2)}%',
      ),
    ];
  }

  List<PieChartSectionData> _noDataSection() {
    return [
      PieChartSectionData(
        color: Colors.grey,
        value: 100,
        title: 'No Data',
        radius: 50,
        titleStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  PieChartSectionData _createPieChartSection({
    required Color color,
    required double value,
    required String title,
  }) {
    return PieChartSectionData(
      color: color,
      value: value,
      title: title,
      radius: 50,
      titleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
