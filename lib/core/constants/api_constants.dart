class ApiConstants {
  ApiConstants._();

  // ⚠️ IMPORTANT — change this per platform you run on:
  //  - Chrome / Web / Desktop  -> http://localhost:5000
  //  - Android Emulator        -> http://10.0.2.2:5000
  //  - iOS Simulator           -> http://localhost:5000
  //  - Real device on same WiFi-> http://<your-pc-lan-ip>:5000
  static const String baseUrl = 'http://localhost:5000';

  static const String branches = '$baseUrl/admin/branches';

  // Manager
  static const String managers = '$baseUrl/admin/managers';

  // Audit Log
  static const String auditLogs = '$baseUrl/admin/audit-logs';
  static String employeeTimeline(int employeeDbId) =>
      '$baseUrl/admin/audit-logs/employee/$employeeDbId';

  // Settings
  static const String settings = '$baseUrl/admin/settings';
  static const String settingsReset = '$baseUrl/admin/settings/reset';

  // Landing Page
  static const String landingPage = '$baseUrl/admin/landing-page';
  static const String landingPageReset = '$baseUrl/admin/landing-page/reset';

  // Reports
  static const String salesReport = '$baseUrl/admin/reports/sales';
  static const String reportCustomers = '$baseUrl/admin/reports/customers';
  static const String purchaseReport = '$baseUrl/admin/reports/purchases';
  static const String reportSuppliers = '$baseUrl/admin/reports/suppliers';
  static const String inventoryReport = '$baseUrl/admin/reports/inventory';
  static const String reportCategories = '$baseUrl/admin/reports/categories';

  static const String authHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';

  static const String loginRoute = '/api/auth/login';
  static const String logoutRoute = '/api/auth/logout';
  static const String meRoute = '/api/auth/me';
  static const String employeesRoute = '/api/employees';
}
