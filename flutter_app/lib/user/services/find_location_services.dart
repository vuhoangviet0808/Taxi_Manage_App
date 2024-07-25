import 'dart:convert';
import 'package:flutter_app/user/models/search_infor.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import '../models/search_infor.dart';

class FindLocationService {
  Future<List<Feature>> addressSuggestion(String address) async {
    try {
      // Gửi yêu cầu GET đến API với các tham số truy vấn
      Response response = await Dio().get(
        'https://photon.komoot.io/api/',
        queryParameters: {"q": address, "limit": 5},
      );
      // In ra dữ liệu JSON trả về từ API
      print(response.data);
      // Lấy dữ liệu JSON từ phản hồi
      final json = response.data;

      // Chuyển đổi JSON thành danh sách Feature
      return (json['features'] as List)
          .map((e) => Feature.fromJson(e))
          .toList();
    } catch (e) {
      // Xử lý ngoại lệ nếu có
      print('Error: $e');
      return [];
    }
  }
}