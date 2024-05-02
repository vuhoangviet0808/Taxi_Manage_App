// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool online = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        constraints:  BoxConstraints.expand(),
        color: Colors.white,
        child:  Positioned(
          left: 0,
          bottom: 0,
          right: 0,
          child: Column(
            children:<Widget> [
              AppBar(
                backgroundColor: Colors.black87,
                elevation: 0,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget> [
                    Text(
                      'HUST DRIVER',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Feliz - 29BK01405',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white
                      ),
                    )
                  ],
                ),
                leading: TextButton(
                  onPressed: (){
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  child: Icon(
                    Icons.menu,
                    size: 30,
                    color: Colors.white,
                    )
                ),
                actions:<Widget> [
                  Transform.scale(
                    scale: 1, // Thay đổi kích thước của switch
                    child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10), // Thêm khoảng cách trên dưới
                    child: Switch(
                    value: online,
                    onChanged: toggleSwitch,
                    activeColor: Colors.green,
                    activeTrackColor: Colors.green[200], // Màu sắc khi switch bật
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey[400], // Màu sắc khi switch tắt
                    splashRadius: 10, // Kích thước vùng chạm nước khi bật
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Placeholder(),
      ),
    );
  }
  void toggleSwitch(bool value){
      setState(() {
        online = value;
      });
    if(online){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Placeholder()));
    }
    }
}
