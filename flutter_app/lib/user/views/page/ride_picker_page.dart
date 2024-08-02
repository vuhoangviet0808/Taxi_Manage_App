// ignore_for_file: prefer_typing_uninitialized_variables, sized_box_for_whitespace

import "package:flutter/material.dart";
import '../../models/place_item_res.dart';
import '../../services/place_bloc_services.dart';

class RiderPickerPage extends StatefulWidget {
  final String selectedAddress;
  final Function(PlaceItemRes, bool) onSelected;
  final bool _isFromAddress;
  RiderPickerPage(this.selectedAddress, this.onSelected, this._isFromAddress);

  @override
  State<RiderPickerPage> createState() => _RiderPickerPageState();
}

class _RiderPickerPageState extends State<RiderPickerPage> {
  late TextEditingController _addressController;
  var placeBloc = PlaceBloc();
  @override
  void initState() {
    _addressController = TextEditingController(text: widget.selectedAddress);
    super.initState();
  }

  @override
  void dispose() {
    placeBloc.dispose();
    super.dispose();
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
                    alignment: AlignmentDirectional.centerStart,
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
                          onSubmitted: (str) {
                            placeBloc.searchPlace(str);
                          },
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
              padding: EdgeInsets.only(top: 20),
              child: StreamBuilder(
                stream: placeBloc.placeStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data.toString());
                  }
                  if (snapshot.data == "start") {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<PlaceItemRes>? places =
                      snapshot.data as List<PlaceItemRes>?;
                  if (places == null || places.isEmpty) {
                    return Center(
                      child: Text("No places found"),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: places.length,
                    separatorBuilder: (context, index) =>
                        Divider(height: 1, color: Colors.grey),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(places[index].name),
                        subtitle: Text(places[index].address),
                        onTap: () {
                          print("on tap");
                          Navigator.of(context).pop();
                          widget.onSelected(
                              places[index], widget._isFromAddress);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
