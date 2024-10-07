import 'package:flutter/material.dart';
import 'package:flutter_app/user/viewmodels/user_view_model.dart';
import 'package:flutter_app/user/views/page/update_user_page.dart';
import 'package:provider/provider.dart';
import '../../../common/views/login_page.dart';
import '../../models/user.dart';
import '../page/ride_history_page.dart';

class HomeMenu extends StatefulWidget {
  final User user;
  HomeMenu({Key? key, required this.user}) : super(key: key);

  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Thêm phần ảnh đại diện và tên user ở đầu menu
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/user/avatar.png"), // Đường dẫn đến ảnh đại diện
                  ),
                  SizedBox(height: 10), // Khoảng cách giữa avatar và tên user
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '${widget.user.lastname}!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal, // Màu cho lastname
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(), // Đường kẻ ngăn cách
            buildMenuItem(
              icon: "assets/user/userlogin.png",
              text: "My profile",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (context) => UserViewModel(),
                      child: UpdateUserPage(user: widget.user),
                    ),
                  ),
                );
              },
            ),
            buildMenuItem(
              icon: "assets/user/refresh-ccw.png",
              text: "Ride History",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RideHistoryPage(userID: widget.user.User_ID),
                  ),
                );
              },
            ),
            buildMenuItem(
              icon: "assets/user/percent.png",
              text: "Offers",
              onTap: () {},
            ),
            buildMenuItem(
              icon: "assets/user/whitebell.png",
              text: "Notifications",
              onTap: () {},
            ),
            buildMenuItem(
              icon: "assets/user/help-circle.png",
              text: "Help & support",
              onTap: () {},
            ),
            buildMenuItem(
              icon: "assets/user/log-out.png",
              text: "Log out",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({required String icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Image.asset(
        icon,
        color: Colors.teal, // Màu của icon
      ),
      title: Text(
        text,
        style: TextStyle(fontSize: 18, color: Color(0xff323643)),
      ),
      onTap: onTap,
    );
  }
}
