import 'dart:convert';
import '../helpers/api_config.dart';
import '../models/apartment_browse_model.dart';
 import 'package:http/http.dart'as http;
class BrowseApartmentService {

  Future<List<ApartmentBrowseModel>> getAllApartment(
      {required int status}) async {
    http.Response response = await http.get(
        Uri.parse("${ApiConfig().baseUrl}/api/apartment?status=$status"));
     if (response.statusCode == 200) {
      Map<String, dynamic>apartment = jsonDecode(response.body);
      List<dynamic> artmentsJson = apartment["data"];
      List<ApartmentBrowseModel>apartmentList = [];
      for (int i = 0; i < artmentsJson.length; i++) {
        apartmentList.add(ApartmentBrowseModel.fromJson(artmentsJson[i]));
      }
        return apartmentList;
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<void> acceptApartment(int apartmentId) async {
    final response = await http.patch(
      Uri.parse("${ApiConfig().baseUrl}/api/ok/$apartmentId"),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse["message"]);
      print(response.body);
    } else {
      throw Exception("Failed to accept Apartment: ${response.body}");
    }
  }


  Future<void> rejectApartment(int apartmentId) async {
    http.Response response = await http.patch(
        Uri.parse("${ApiConfig().baseUrl}/api/no/$apartmentId"));
    if (response.statusCode == 200) {
      final resposeJson = jsonDecode(response.body);
      print(resposeJson["message"]);
    } else {
      throw Exception("Failed to accept Apartment: ${response.body}");
    }
  }
}