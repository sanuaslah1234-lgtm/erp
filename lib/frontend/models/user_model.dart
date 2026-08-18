class UserModel {
  final int? id;
  final String email;
  final String role;
  final bool isActive;
  final String? lastLoginAt;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    this.id,
    required this.email,
    this.role = 'employee',
    this.isActive = true,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'employee',
      isActive: json['is_active'] == true,
      lastLoginAt: json['last_login_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'is_active': isActive,
      'last_login_at': lastLoginAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
