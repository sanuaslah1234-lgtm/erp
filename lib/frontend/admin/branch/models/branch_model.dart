class BranchModel {
  final int? id;
  final String code;
  final String name;
  final String address;
  final String city;
  final String state;
  final String phone;
  final String email;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BranchModel({
    this.id,
    required this.code,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.phone,
    required this.email,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  // ============================================================
  // FROM MAP
  // ============================================================

  factory BranchModel.fromMap(Map<String, dynamic> map) {
    return BranchModel(
      id: map['id'] == null
          ? null
          : int.tryParse(map['id'].toString()),
      code: map['code']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      city: map['city']?.toString() ?? '',
      state: map['state']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      isActive: map['is_active'] == true ||
          map['isActive'] == true,
      createdAt: map['created_at'] == null
          ? null
          : DateTime.tryParse(
              map['created_at'].toString(),
            ),
      updatedAt: map['updated_at'] == null
          ? null
          : DateTime.tryParse(
              map['updated_at'].toString(),
            ),
    );
  }

  // ============================================================
  // TO MAP
  // ============================================================

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'phone': phone,
      'email': email,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // ============================================================
  // FROM JSON
  // ============================================================

  factory BranchModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BranchModel.fromMap(json);
  }

  // ============================================================
  // TO JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return toMap();
  }

  // ============================================================
  // COPY WITH
  // ============================================================

  BranchModel copyWith({
    int? id,
    String? code,
    String? name,
    String? address,
    String? city,
    String? state,
    String? phone,
    String? email,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BranchModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

