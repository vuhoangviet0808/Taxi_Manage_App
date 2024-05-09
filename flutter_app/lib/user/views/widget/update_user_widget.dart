
import "package:flutter/material.dart";


class UpdateUserWidget extends StatefulWidget {
  TextEditingController _SDTEditingController = TextEditingController();
  @override
  _UpdateUserWidgetState createState() => _UpdateUserWidgetState();
}

class _UpdateUserWidgetState extends State<UpdateUserWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 80, 0, 20),
              child: TextField(
                controller: widget._SDTEditingController,
                style: TextStyle(fontSize: 18, color: Colors.black),
                decoration: InputDecoration(
                  labelText: "",
                  prefixIcon: SizedBox(
                    width: 50, child: Image.asset("assets/user/phone.png")),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffCED0D2), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(6)))),
              ),
            )
          ],
        ),
      )
    );
  }
  @override
  void dispose() {
   
    widget._SDTEditingController.dispose();
    super.dispose();
  }
}