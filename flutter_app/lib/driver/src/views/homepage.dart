import 'package:flutter/material.dart';
import '../models/driver.dart';
import 'homemenu.dart';
import 'riderpicker.dart';

class HomePage extends StatefulWidget {
  final Driver driver;
  HomePage({Key? key, required this.driver}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool online = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: HomeMenu(driver: widget.driver),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.black87,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.menu, color: Colors.white, size: 40),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  SizedBox(width: 10),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'HUST DRIVER',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Transform.scale(
                    scale: 1.2,
                    child: Switch(
                      value: online,
                      onChanged: toggleSwitch,
                      activeColor: Colors.green,
                      activeTrackColor: Colors.green[200],
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey[400],
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    online ? "Online" : "Offline",
                    style: TextStyle(
                      color: online ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.directions_car,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Waiting for ride requests...',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void toggleSwitch(bool value) {
    setState(() {
      online = value;
    });
    if (online) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RiderPicker(driver: widget.driver),
      ));
    }
  }
}
