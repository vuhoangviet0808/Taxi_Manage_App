import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<String> fetchData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/hello'));

    if (response.statusCode == 200) {
      // Nếu máy chủ trả về một phản hồi thành công
      var data = json.decode(response.body);
      return data['message'];
    } else {
      // Nếu máy chủ không trả về một phản hồi thành công
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter & Flask Demo'),
        ),
        body: Center(
          child: FutureBuilder<String>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // Mặc định, hiển thị một spinner loading
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
