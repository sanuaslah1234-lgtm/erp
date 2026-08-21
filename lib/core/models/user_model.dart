class UserModel {
  final int? id;
  final String email;
  final String? passwordHash;
  final String role;
  final bool isActive;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    this.id,
    required this.email,
    this.passwordHash,
    this.role = 'employee',
    this.isActive = true,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel.fromMap(json);
  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      email: json['email']?.toString() ?? '',
      passwordHash: json['password_hash']?.toString(),
      role: json['role']?.toString() ?? 'employee',
      isActive: json['is_active'] == true,
      lastLoginAt: json['last_login_at'] != null ? DateTime.tryParse(json['last_login_at'].toString()) : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson({bool includePassword = false}) {
    return {
      'id': id,
      'email': email,
      if (includePassword && passwordHash != null) 'password_hash': passwordHash,
      'role': role,
      'is_active': isActive,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
