import 'package:flutter/material.dart';
import 'package:flutter_app/driver/src/services/driver_info_services.dart';
import 'package:flutter_app/driver/src/services/logout.dart';
import 'package:flutter_app/driver/src/views/revenue_summary.dart';
import 'package:provider/provider.dart';

import '../models/driver.dart';
import '../viewmodels/driver_viewmodel.dart';
import 'driver_infor.dart';
import 'ride_history.dart';

class HomeMenu extends StatefulWidget {
  final Driver driver;

  HomeMenu({required this.driver});

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  List<CabRide> _cabRides = [];
  String? _errorMes;

  @override
  void initState() {
    super.initState();
    fetchCabRides();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.black54,
                  width: double.infinity,
                  height: 180,
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/driver/anhthe.jpg'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              ' ${widget.driver.lastname} ${widget.driver.firstname}',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            Text(
                              'CCCD: ${widget.driver.CCCD}',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 20,
                thickness: 0,
                color: Colors.white,
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: Text(
                          'Thông tin cá nhân',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                create: (context) => DriverViewModel(),
                                child: DriverInfor(driver: widget.driver),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      height: 15,
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.wallet),
                        title: Text(
                          'Ví tài khoản',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        onTap: () {
                          showWallet();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      height: 15,
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.attach_money),
                        title: Text(
                          'Tổng hợp doanh thu',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DailyRevenueSummary(
                                  driverId: widget.driver.Driver_ID),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      height: 15,
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.history_rounded),
                        title: Text(
                          'Lịch sử chuyến đi',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RideHistoryPage(
                                  driverId: widget.driver.Driver_ID),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      height: 15,
                    ),
                    Card(
                      child: ListTile(
                        leading: Image(
                          image: AssetImage('assets/driver/notif-icon.png'),
                          width: 20,
                          height: 20,
                        ),
                        title: Text(
                          'Thông báo',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      height: 15,
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.logout_outlined),
                        title: Text(
                          'Đăng xuất',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        onTap: () async {
                          LogOutService().logout(context); // gọi hàm logout
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showWallet() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.cyan],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.account_balance_wallet,
                        size: 40, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Ví tài khoản",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Số dư hiện tại:',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.driver.Wallet.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Icon(Icons.monetization_on,
                                size: 40, color: Colors.green),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void fetchCabRides() async {
    CabRideInfoService cabRides = CabRideInfoService();
    try {
      List<CabRide> rides = await cabRides.getCabRide(widget.driver.Driver_ID);
      setState(() {
        _cabRides = rides;
        _errorMes = rides.isEmpty ? "Không có dữ liệu chuyến đi" : null;
        totalPrice();
      });
    } catch (e) {
      setState(() {
        _errorMes = "Lỗi khi lấy dữ liệu: $e";
      });
    }
  }

  void totalPrice() {
    double totalPrice = _cabRides.fold(0, (sum, ride) => sum + ride.price);
    setState(() {
      if (_errorMes == null) {
        widget.driver.Wallet = double.parse(totalPrice.toStringAsFixed(2));
      } else {
        widget.driver.Wallet = 0;
      }
    });
  }
}
