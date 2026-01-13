import 'package:admin/helpers/api_config.dart';

class BuildImageUrl {
  String buildImageUrl(String path){
    return "${ApiConfig().baseUrl}/storage/$path";
  }
}