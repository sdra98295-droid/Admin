class ApartmentBrowseModel {
  final int id;
  final int ?ownerId;
  final int space;
  final int ?rooms;
  final String price;
  final String?contractImage;
  final String country;
  final String city;
  final String description;
  final int avaregRate;
  final int status;
  final String ?deletedAt;
  final String createdAt;
  final String updatedAt;
  final Owner ?owner;
  final List<dynamic>bookedPeriods;

  ApartmentBrowseModel({
    required this.id,
    required this.ownerId,
    required this.space,
    required this.contractImage,
    required this.rooms,
    required this.price,
    required this.country,
    required this.city,
    required this.description,
    required this.avaregRate,
    required this.status,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.owner,
    required this.bookedPeriods,
  });

  factory ApartmentBrowseModel.fromJson(Map<String, dynamic> json) {
    return ApartmentBrowseModel(
      id: json["id"],
      ownerId: json["owner_id"],
      space: json["space"],
      rooms: json["rooms"] ?? 0,
      price: json["price"],
      contractImage: json["contract"]??null,
      country: json["country"]?"",
      city: json["city"],
      description: json["description"] ?? "",
       avaregRate: json["average_rating"] ?? 0,
      status: json["status"],
      deletedAt: json["deleted_at"]??"",
      createdAt: json["created_at"]??"",
      updatedAt: json["updated_at"]??"",
      bookedPeriods: json['booked_periods'] ?? [],
      owner: json['owner'] != null
          ? Owner.fromJson(json['owner'])
          : null,
    );
  }
}

class Owner {
  final int id;
  final String firstName;
  final String lastName;

  Owner({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json["id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
    );
  }
}

