import 'dart:convert';
import '../models/users_browse_model.dart';
import 'package:http/http.dart'as http;
class BrowseUsersService {

  Future<List<UsersBrowseModel>> getAllusers(
      {required int isApproved}) async {
    http.Response response = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/browse?is_approved=$isApproved"));
    //print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic>user = jsonDecode(response.body);
      List<dynamic> Listuser = user["users"];
      List<UsersBrowseModel>userList = [];
      for (int i = 0; i < Listuser.length; i++) {
        userList.add(UsersBrowseModel.fromJson(Listuser[i]));
      }
      print(Listuser[Listuser.length-1]);
      return userList;
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<void> acceptUser(int userId) async {
    final response = await http.patch(
      Uri.parse("http://127.0.0.1:8000/api/accept/$userId"),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse["message"]);
    } else {
      throw Exception("Failed to accept user: ${response.body}");
    }
  }


  Future<void> rejectUser(int userId) async {
    http.Response response = await http.patch(
        Uri.parse("http://127.0.0.1:8000/api/reject/$userId"));
    if (response.statusCode == 200) {
      final resposeJson = jsonDecode(response.body);
      print(resposeJson["message"]);
    } else {
      throw Exception("Failed to accept user: ${response.body}");
    }
  }
}