class EmployeeModel {
  final String? id;
  final String? fullName;
  final String? email;
  final String? employeeId;
  final String? phone;

  final String? role;
  final String? roleId;

  final String? branchId;
  final String? branch;

  final String? type;

  final bool isVerified;
  final bool firstLogin;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const EmployeeModel({
    this.id,
    this.fullName,
    this.email,
    this.employeeId,
    this.phone,
    this.role,
    this.roleId,
    this.branchId,
    this.branch,
    this.type,
    this.isVerified = false,
    this.firstLogin = true,
    this.createdAt,
    this.updatedAt,
  });

  // --------------------------------------------------
  // BACKWARD COMPATIBILITY
  // --------------------------------------------------

  String get name => fullName ?? 'Unnamed Employee';

  String get displayEmployeeId =>
      employeeId?.trim().isNotEmpty == true
          ? employeeId!
          : 'N/A';

  String get displayRole =>
      role?.trim().isNotEmpty == true
          ? role!
          : 'No Role';

  String get displayBranch =>
      branch?.trim().isNotEmpty == true
          ? branch!
          : 'N/A';

  String get displayEmail =>
      email?.trim().isNotEmpty == true
          ? email!
          : 'N/A';

  String get displayPhone =>
      phone?.trim().isNotEmpty == true
          ? phone!
          : 'N/A';

  bool get verified => isVerified;

  String get initials {
    final value = name.trim();

    if (value.isEmpty) {
      return 'U';
    }

    final parts = value
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'
        .toUpperCase();
  }

  factory EmployeeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EmployeeModel(
      id: json['id']?.toString(),

      fullName:
          json['fullName']?.toString(),

      email:
          json['email']?.toString(),

      employeeId:
          json['employeeId']?.toString(),

      phone:
          json['phone']?.toString(),

      role:
          json['role']?.toString(),

      roleId:
          json['roleId']?.toString(),

      branchId:
          json['branchId']?.toString(),

      branch:
          json['branch']?.toString() ??
          json['branchName']?.toString(),

      type:
          json['type']?.toString(),

      isVerified:
          json['isVerified'] == true,

      firstLogin:
          json['firstLogin'] == true,

      createdAt:
          _parseDate(json['createdAt']),

      updatedAt:
          _parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'employeeId': employeeId,
      'phone': phone,
      'role': role,
      'roleId': roleId,
      'branchId': branchId,
      'branch': branch,
      'type': type,
      'isVerified': isVerified,
      'firstLogin': firstLogin,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(
      value.toString(),
    );
  }
}