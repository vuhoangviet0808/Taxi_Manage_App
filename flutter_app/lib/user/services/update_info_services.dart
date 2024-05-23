// ignore_for_file: unused_import, non_constant_identifier_names, prefer_const_declarations

import 'dart:async';

import 'package:flutter/material.dart';
import '../models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import "../views/widget/update_user_widget.dart";

class Bloc {
  // Khai báo StreamController với kiểu dữ liệu là String
  StreamController<String> _SDTEditingController = StreamController<String>();

  // Phương thức getter để truy cập vào stream
  Stream<String> get sdtStream => _SDTEditingController.stream;

  // Constructor của lớp Bloc
  Bloc();

  // Phương thức dispose để đóng StreamController khi không cần thiết nữa
  void dispose() {
    _SDTEditingController.close();
  }

  // Phương thức để gửi số điện thoại lên Flask
  void sendSdtToFlask(String data) async {
    // Địa chỉ của Flask
    final String baseUrl = 'http://10.0.2.2:5000/process_data';

    // Dữ liệu cần gửi đi
    var body = {'data': data};

    // Gửi HTTP post
    var response = await http.post(Uri.parse(baseUrl), body: body);

    // Kiểm tra kết quả
    if (response.statusCode == 200) {
      print('Gửi số điện thoại thành công');
    } else {
      print('Gửi số điện thoại thất bại. Lỗi: ${response.reasonPhrase}');
    }
  }

  void senSDTtoFlask(TextEditingController controller) {
    String SDT = controller.text;
    sendSdtToFlask(SDT);
  }
}
