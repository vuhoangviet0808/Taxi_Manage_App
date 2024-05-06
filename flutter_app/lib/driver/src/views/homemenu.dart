// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';


class HomeMenu extends StatefulWidget {


  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children:<Widget> [
              Center(
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.black54,
                  width: double.infinity,
                  height: 150,
                  child: Row(
                    children:<Widget> [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/images/anhthe.jpg'),
                      ),
                      SizedBox(width: 10,),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children:<Widget> [
                          Text(
                            'Nguyễn Khánh Duy',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white
                            ),
                          ),
                          Text(
                            'ID: 20225830',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white
                            ),
                          )
                        ],
                      ))
                    ],
                  ),
                ),
              ),
              Divider(
                height: 20,
                thickness: 0,
                color: Colors.black,
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.wallet),
                        title: Text('Ví tài khoản',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                        ),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.attach_money),
                        title: Text('Tổng hợp doanh thu',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                        ),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.percent),
                        title: Text('Tỷ lệ hoạt động',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                        ),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.history_rounded),
                        title: Text('Lịch sử',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                        ),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.message_rounded),
                        title: Text('Tin nhắn từ tổng đài',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                        ),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Image(image: AssetImage('assets/driver/notif-icon.png'), width: 20, height: 20,),
                        title: Text('Thông báo',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                        ),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.logout_outlined),
                        title: Text('Đăng xuất',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                        ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }
}