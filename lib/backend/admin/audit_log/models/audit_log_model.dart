class AuditLogModel {
  final int id;
  final String action;
  final String module;
  final String description;
  final String ipAddress;
  final DateTime? createdAt;
  final int? employeeDbId;
  final String? employeeId;
  final String? employeeName;
  final String? employeeEmail;

  const AuditLogModel({
    required this.id,
    required this.action,
    required this.module,
    required this.description,
    required this.ipAddress,
    this.createdAt,
    this.employeeDbId,
    this.employeeId,
    this.employeeName,
    this.employeeEmail,
  });

  factory AuditLogModel.fromMap(Map<String, dynamic> map) {
    return AuditLogModel(
      id: map['id'] as int,
      action: map['action']?.toString() ?? '',
      module: map['module']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      ipAddress: map['ip_address']?.toString() ?? '',
      createdAt: map['created_at'] == null
          ? null
          : DateTime.tryParse(map['created_at'].toString()),
      employeeDbId: map['employee_db_id'] as int?,
      employeeId: map['employee_id']?.toString(),
      employeeName: map['employee_name']?.toString(),
      employeeEmail: map['employee_email']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'action': action,
      'module': module,
      'description': description,
      'ip_address': ipAddress,
      'created_at': createdAt?.toIso8601String(),
      'employee_db_id': employeeDbId,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'employee_email': employeeEmail,
    };
  }
}