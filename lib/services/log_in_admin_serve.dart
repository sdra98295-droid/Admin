import 'dart:convert';

import 'package:http/http.dart'as http;

import '../helpers/errors.dart';
class LogInAdminServe {
  Future<void>logInAdmin({required nameAdmin,required password})async{
   http.Response response =await http.post(Uri.parse("http://127.0.0.1:8000/api/admin-login"),body: {
      "name": nameAdmin,
      "password": password,
    });
   var jsonData = jsonDecode(response.body);

   if(response.statusCode==200) {
     return ;
   }else{
     throw ApiException(jsonData["message"],response.statusCode);
   }

  }
}