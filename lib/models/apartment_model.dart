class Apartment {
  int id;
  int ownerid;
  String city;
  String country;
  String space;
  String price;
  String? description;
  List<String> images;
  int status; // 0 = pending, 1 = approved, 2 = rejected
  DateTime createdAt;
  DateTime? updatedAt;

  Apartment({
    required this.id,
    required this.ownerid,
    required this.city,
    required this.country,
    required this.space,
    required this.price,
    this.description,
    required this.images,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      id: json['id'] ?? 0,
      ownerid: json['owner_id'] ?? 0,
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      space: json['space']?.toString() ?? '0',
      price: json['price']?.toString() ?? '0',
      description: json['description'],
      images: (json['images'] is List)
          ? List<String>.from(json['images'].map((img) => img['image']))
          : [],
      status: json['status'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ownerid': ownerid,
      'city': city,
      'country': country,
      'space': space,
      'price': price,
      'description': description,
      'images': images,
      'status': status,
    };
  }
/*
  String get statusText {
    switch (status) {
      case 0:
        return 'قيد المراجعة';
      case 1:
        return 'مقبولة';
      case 2:
        return 'مرفوضة';
      default:
        return 'غير معروف';
    }
  }*/
}