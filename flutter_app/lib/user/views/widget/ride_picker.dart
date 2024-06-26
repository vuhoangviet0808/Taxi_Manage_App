// ignore_for_file: library_private_types_in_public_api, sized_box_for_whitespace

import "package:flutter/material.dart";
import "../page/ride_picker_page.dart";
import "../../models/place_item_res.dart";
class RidePicker extends StatefulWidget {
 
  final Function(PlaceItemRes, bool) onSelected;
   RidePicker(this.onSelected);

   @override
  _RidePickerState createState() => _RidePickerState();
}

class _RidePickerState extends State<RidePicker> {
   PlaceItemRes? fromAddress;
   PlaceItemRes? toAddress;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Color(0x88999999),
            offset: Offset(0,5),
            blurRadius: 5.0,
          )
        ]),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 50,
            child: TextButton(
              onPressed: () {
                  String address = fromAddress?.name ?? "";
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RiderPickerPage(
                      address,
                      (place, isFrom){
                        widget.onSelected(place, isFrom);
                        fromAddress = place;
                        setState(() {});
                      },
                      true
                    )
                  ));
              },
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                      height: 50,
                      child: Center(
                        child: Image.asset("assets/user/mappointer.png"),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      width: 40,
                      height: 50,
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            
                          },
                          child: Image.asset("assets/user/x.png")),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40, right: 50),
                      child: TextField(
                        
                        style: 
                        TextStyle(fontSize: 16, color: Color(0xff323643)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 50,
            child: TextButton(
              onPressed: () {},
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                      height: 50,
                      child: Center(
                        child: Image.asset("assets/user/navigation.png"),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      width: 40,
                      height: 50,
                      child: Center(
                        child: Image.asset("assets/user/x.png"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40, right: 50),
                      child: Text(
                        fromAddress?.name ?? "From",
                        overflow: TextOverflow.ellipsis,
                        style: 
                        TextStyle(fontSize: 16, color: Color(0xff323643)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
        )
    );
  }
}