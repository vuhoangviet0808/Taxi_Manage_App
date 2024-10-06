import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/admin/models/booking_request_model.dart';

class BookingRequestService {
  Future<List<BookingRequest>> fetchBookingRequests() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5000/admin/booking_request'));

    if (response.statusCode == 200) {
      List<dynamic> bookingsData = json.decode(response.body);
      List<BookingRequest> bookingInfo = [];

      for (var bookingData in bookingsData) {
        if (bookingData['booking_id'] != null &&
            bookingData['pickup_location'] != null &&
            bookingData['status'] != null) {
          String bookingID = bookingData['booking_id'].toString();
          bookingInfo.add(BookingRequest(
            bookingID,
            bookingData['pickup_location'].toString(),
            bookingData['request_time'].toString(),
            bookingData['status'].toString(),
          ));
        } else {
          print('Null data received for a booking request: $bookingData');
        }
      }
      return bookingInfo;
    } else {
      print('Error fetching booking requests: ${response.statusCode}');
      throw Exception('Failed to fetch booking requests');
    }
  }

  Future<FullBookingRequest> fetchEachBookingRequest(
      String bookingRequestID) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/admin/booking_request/$bookingRequestID'),
    );

    if (response.statusCode == 200) {
      dynamic responseBody = json.decode(response.body);

      if (responseBody is List) {
        if (responseBody.isNotEmpty) {
          responseBody = responseBody.first;
        } else {
          print(
              'Empty list received for the booking request with ID: $bookingRequestID');
          throw Exception('Empty list received for the booking request');
        }
      }

      if (responseBody is Map<String, dynamic>) {
        if (responseBody['booking_id'] != null) {
          return FullBookingRequest(
            responseBody['booking_id'].toString(),
            responseBody['user_id']?.toString() ?? '',
            responseBody['requested_car_type']?.toString() ?? '',
            responseBody['pickup_location']?.toString() ?? '',
            responseBody['pickup_latitude']?.toString() ?? '',
            responseBody['pickup_longitude']?.toString() ?? '',
            responseBody['dropoff_location']?.toString() ?? '',
            responseBody['destination_latitude']?.toString() ?? '',
            responseBody['destination_longitude']?.toString() ?? '',
            responseBody['price']?.toString() ?? '',
            responseBody['request_time']?.toString() ?? '',
            responseBody['status']?.toString() ?? '',
            responseBody['driver_id']?.toString() ?? '',
          );
        } else {
          print(
              'Null data received for the booking request with ID: $bookingRequestID');
          throw Exception('Null data received for the booking request');
        }
      } else {
        print(
            'Invalid data type received for the booking request with ID: $bookingRequestID');
        throw Exception('Invalid data type received for the booking request');
      }
    } else {
      throw Exception(
          'Failed to load booking request with ID: $bookingRequestID');
    }
  }

  Future<int> fetchTotalBookingRequests() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/admin/booking_request/total'),
    );

    if (response.statusCode == 200) {
      dynamic responseBody = json.decode(response.body);
      if (responseBody['pending_booking_requests'] != null) {
        return responseBody['pending_booking_requests'];
      } else {
        print('Invalid data received for total booking requests count.');
        throw Exception(
            'Invalid data received for total booking requests count');
      }
    } else {
      print('Error fetching total booking requests: ${response.statusCode}');
      throw Exception('Failed to fetch total booking requests');
    }
  }

  // Method mới để lấy số lượng xe 4_seat và 6_seat
  Future<Map<String, int>> fetchCarTypeCounts() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/admin/booking_request/car_type'),
    );

    if (response.statusCode == 200) {
      dynamic responseBody = json.decode(response.body);
      if (responseBody['4_seat'] != null && responseBody['6_seat'] != null) {
        return {
          '4_seat': responseBody['4_seat'],
          '6_seat': responseBody['6_seat'],
        };
      } else {
        print('Invalid data received for car type counts.');
        throw Exception('Invalid data received for car type counts');
      }
    } else {
      print('Error fetching car type counts: ${response.statusCode}');
      throw Exception('Failed to fetch car type counts');
    }
  }
}
