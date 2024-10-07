// ignore_for_file: library_private_types_in_public_api, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_app/user/views/page/map_page.dart';
import 'package:flutter_app/user/views/page/trip_info_panel.dart';
import '../page/ride_picker_page.dart';
import '../page/trip_info_panel.dart';
import '../../models/user.dart';
class RidePicker extends StatefulWidget {
  final User user;
  RidePicker({Key? key, required this.user}) : super(key: key);
  @override
  _RidePickerState createState() => _RidePickerState();
}

class _RidePickerState extends State<RidePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Color(0x88999999),
            offset: Offset(0, 5),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.teal), // Viền xanh
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MapPage(user: widget.user),
                ));
              },
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.orange),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      "Bạn muốn đi đâu?",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff323643),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCategoryButton(Icons.home, 'Thêm Nhà'),
              _buildCategoryButton(Icons.business, 'Thêm Công ty'),
              _buildCategoryButton(Icons.location_city, 'Thêm địa chỉ'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.teal.withOpacity(0.1),
          child: Icon(icon, color: Colors.teal),
        ),
        SizedBox(height: 4.0),
        Text(label, style: TextStyle(fontSize: 14.0)),
      ],
    );
  }
}
