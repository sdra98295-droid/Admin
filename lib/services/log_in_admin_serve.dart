import 'dart:convert';
import 'package:admin/helpers/api_config.dart';
import 'package:http/http.dart'as http;
import '../helpers/errors.dart';
class LogInAdminServe {
  Future<void>logInAdmin({required nameAdmin,required password})async{
   http.Response response =await http.post(Uri.parse("${ApiConfig().baseUrl}/api/admin-login"),body: {
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