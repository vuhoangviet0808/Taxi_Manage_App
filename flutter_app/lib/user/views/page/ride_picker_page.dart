// ignore_for_file: prefer_typing_uninitialized_variables, sized_box_for_whitespace

import "package:flutter/material.dart";

class RiderPickerPage extends StatefulWidget {
  @override
  State<RiderPickerPage> createState() => _RiderPickerPageState();
}

class _RiderPickerPageState extends State<RiderPickerPage> {
  var _addressController;
  @override
  void initState(){
    _addressController = TextEditingController(text: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Color(0xfff8f8f8),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  child: Stack(
                    alignment:AlignmentDirectional.centerStart,
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                        height: 60,
                        child: Center(
                          child: Image.asset("assets/user/mappointer.png"),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        width: 40,
                        height: 60,
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              _addressController.text = "";
                            },
                            child: Image.asset("assets/user/x.png")),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40, right: 50),
                        child: TextField(
                          controller: _addressController,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (str){},
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
        ),
      ),
    );
  }
}