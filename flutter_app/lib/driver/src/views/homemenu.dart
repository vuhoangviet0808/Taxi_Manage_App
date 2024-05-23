// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/driver.dart';
import '../viewmodels/driver_viewmodel.dart';
import 'driver_infor.dart';

class HomeMenu extends StatefulWidget {
  final Driver driver;
  HomeMenu({required this.driver});
  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
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
                  height: 120,
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
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          Text(
                            'CCCD: ${widget.driver.CCCD}',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          )
                        ],
                      ))
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
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
                                    child: DriverInfor(driver: widget.driver))),
                          );
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.wallet),
                        title: Text(
                          'Ví tài khoản',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        onTap: () {
                          show_wallet();
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.attach_money),
                        title: Text(
                          'Tổng hợp doanh thu',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.percent),
                        title: Text(
                          'Tỷ lệ hoạt động',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.history_rounded),
                        title: Text(
                          'Lịch sử chuyến đi',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.message_rounded),
                        title: Text(
                          'Tin nhắn từ tổng đài',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
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
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.logout_outlined),
                        title: Text(
                          'Đăng xuất',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
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

  void show_wallet() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tiền hiện có"),
          content: SizedBox(
            width: 300,
            height: 100,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Card(
                  child: ListTile(
                    title: Text(
                      'Wallet: ${widget.driver.Wallet} \$',
                      style: TextStyle(fontSize: 16, color: Colors.black),
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
}
