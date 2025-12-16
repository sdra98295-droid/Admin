import 'dart:convert';
import 'package:admin/models/apartment_model.dart';
import 'package:http/http.dart'as http;
class ApartmentService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  static Future<List<Apartment>> getPendingApartments() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/apartment?status=0'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> apartmentList = responseData['data'];

          return apartmentList.map((item) => Apartment.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching apartments: $e');
      return [];
    }
  }

  static Future<bool> acceptApartment(int apartmentId) async {
    try {

      final headers = {'Content-Type': 'application/json'};
      final response = await http.patch(
        Uri.parse('$baseUrl/apartment/$apartmentId/accept'),
        headers: headers,
      );

      return response.statusCode == 200 ; response.statusCode == 204;
    } catch (e) {
      print('Error accepting apartment: $e');
      return false;
    }
  }

  static Future<bool> rejectApartment(int apartmentId) async {

      final response = await http.patch(
        Uri.parse('$baseUrl/apartment/$apartmentId/reject'),
      );
      try{
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error rejecting apartment: $e');
      return false;
    }
  }
}