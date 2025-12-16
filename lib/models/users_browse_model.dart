class UsersBrowseModel {
  final int id;
  final String first_name;
  final String last_name;
  final String?image;
  final String? id_image;
  final String mobile;
  final String birth_date;
  final int is_approved;
  final String created_at;
  final String updated_at;
  UsersBrowseModel({required this.id,
    required this.first_name,
    required this.last_name,
    required this.image,
    required this.id_image,
    required this.mobile,
    required this.birth_date,
    required this.is_approved,
    required this.created_at,
    required this.updated_at});
  factory UsersBrowseModel.fromJson(jsonData){
    return UsersBrowseModel(
        id: jsonData ['id'],
        first_name:jsonData ["first_name"],
        last_name: jsonData["last_name"],
        image: jsonData["image"],
        id_image: jsonData["id_image"],
        mobile: jsonData["mobile"],
        birth_date: jsonData['birth_date'].toString(),
        is_approved: jsonData['is_approved'] ,
        created_at: jsonData["created_at"],
        updated_at: jsonData["updated_at"]);
  }


}