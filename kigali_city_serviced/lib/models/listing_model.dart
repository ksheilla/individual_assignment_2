class ListingModel {
  final String id;
  final String name;
  final String category;
  final String address;
  final String contactNumber;
  final String description;
  final double latitude;
  final double longitude;
  final String createdBy;
  final DateTime createdAt;
  final List<String> bookmarkedBy; // Users who bookmarked this listing

  ListingModel({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.contactNumber,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.createdAt,
    this.bookmarkedBy = const [],
  });

  factory ListingModel.fromMap(Map<String, dynamic> map) {
    return ListingModel(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      address: map['address'] as String,
      contactNumber: map['contactNumber'] as String,
      description: map['description'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      createdBy: map['createdBy'] as String,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
      bookmarkedBy: List<String>.from(map['bookmarkedBy'] as List? ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'address': address,
      'contactNumber': contactNumber,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'bookmarkedBy': bookmarkedBy,
    };
  }

  ListingModel copyWith({
    String? id,
    String? name,
    String? category,
    String? address,
    String? contactNumber,
    String? description,
    double? latitude,
    double? longitude,
    String? createdBy,
    DateTime? createdAt,
    List<String>? bookmarkedBy,
  }) {
    return ListingModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      address: address ?? this.address,
      contactNumber: contactNumber ?? this.contactNumber,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      bookmarkedBy: bookmarkedBy ?? this.bookmarkedBy,
    );
  }
}
