import 'package:erp_software/backend/admin/reports/controllers/reports_controller.dart';
import 'package:erp_software/backend/admin/reports/repositories/reports_repository.dart';
import 'package:erp_software/backend/admin/reports/services/reports_service.dart';
import 'package:erp_software/backend/admin/manager/controllers/manager_controller.dart';
import 'package:erp_software/backend/admin/manager/repositories/manager_repository.dart';
import 'package:erp_software/backend/admin/manager/services/manager_service.dart';
import 'package:erp_software/backend/admin/audit_log/controllers/audit_log_controller.dart';
import 'package:erp_software/backend/admin/audit_log/repositories/audit_log_repository.dart';
import 'package:erp_software/backend/admin/audit_log/services/audit_log_service.dart';
import 'package:erp_software/backend/admin/settings/controllers/settings_controller.dart';
import 'package:erp_software/backend/admin/settings/repositories/settings_repository.dart';
import 'package:erp_software/backend/admin/settings/services/settings_service.dart';
import 'package:erp_software/backend/middleware/cors_middleware.dart';
import 'package:erp_software/backend/admin/branch/controllers/branch_controller.dart';
import 'package:erp_software/backend/admin/branch/repositories/branch_repository.dart';
import 'package:erp_software/backend/admin/branch/services/branch_service.dart';
import 'package:erp_software/backend/controller/employee_controller.dart';
import 'package:erp_software/backend/database/postgres_service.dart';
import 'package:erp_software/backend/services/employee_service.dart';
import 'package:erp_software/backend/admin/landing_page/controllers/landing_page_controller.dart';
import 'package:erp_software/backend/admin/landing_page/repositories/landing_page_repository.dart';
import 'package:erp_software/backend/admin/landing_page/services/landing_page_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

Future<void> main() async {
  final database = PostgresService();

  try {
    // Connect PostgreSQL
    await database.connect();

    print('ERP database is ready');

    final employeeService = EmployeeService(database);

    final employeeController = EmployeeController(employeeService);

    final branchRepository = BranchRepository(database.connection);

    final branchService = BranchService(branchRepository);

    final branchController = BranchController(branchService);

    final reportsRepository = ReportsRepository(database.connection);

    final reportsService = ReportsService(reportsRepository);

    final reportsController = ReportsController(reportsService);

    final managerRepository = ManagerRepository(database.connection);

    final managerService = ManagerService(managerRepository);

    final managerController = ManagerController(managerService);

    final auditLogRepository = AuditLogRepository(database.connection);

    final auditLogService = AuditLogService(auditLogRepository);

    final auditLogController = AuditLogController(auditLogService);

    final settingsRepository = SettingsRepository(database.connection);

    final settingsService = SettingsService(settingsRepository);

    final settingsController = SettingsController(settingsService);
    
    final landingPageRepository = LandingPageRepository(database.connection);
    
    final landingPageService = LandingPageService(landingPageRepository);
    
    final landingPageController = LandingPageController(landingPageService);

    final router = Router();

    router.post('/employees', employeeController.createEmployee);
    router.get('/employees', employeeController.getEmployees);
    router.get('/employees/<id>', employeeController.getEmployeeById);
    router.put('/employees/<id>', employeeController.updateEmployee);
    router.delete('/employees/<id>', employeeController.deleteEmployee);
    router.post('/admin/branches', branchController.createBranch);
    router.get('/admin/branches', branchController.getBranches);
    router.get('/admin/branches/<id>', branchController.getBranchById);
    router.put('/admin/branches/<id>', branchController.updateBranch);
    router.delete('/admin/branches/<id>', branchController.deleteBranch);
    router.get('/admin/reports/sales', reportsController.getSalesReport);
    router.get('/admin/reports/customers', reportsController.getCustomers);
    router.get('/admin/reports/purchases', reportsController.getPurchaseReport);   // NEW
    router.get('/admin/reports/suppliers', reportsController.getSuppliers);        // NEW
    router.get('/admin/reports/inventory', reportsController.getInventoryReport);  // NEW
    router.get('/admin/reports/categories', reportsController.getCategories);
    router.post('/admin/managers', managerController.createManager); // NEW
    router.get('/admin/managers', managerController.getManagers); // NEW
    router.get('/admin/managers/<id>', managerController.getManagerById); // NEW
    router.put('/admin/managers/<id>', managerController.updateManager); // NEW
    router.delete('/admin/managers/<id>', managerController.deleteManager);
    router.get('/admin/audit-logs', auditLogController.getLogs);
    router.get('/admin/audit-logs/employee/<id>', auditLogController.getEmployeeTimeline,);
    router.get('/admin/settings', settingsController.getSettings);
    router.put('/admin/settings', settingsController.updateSettings);
    router.post('/admin/settings/reset', settingsController.resetSettings);
     router.get('/admin/landing-page', landingPageController.getSettings);
    router.put('/admin/landing-page', landingPageController.updateSettings);
    router.post('/admin/landing-page/reset', landingPageController.resetSettings);
    final handler = Pipeline()
        .addMiddleware(corsHeaders())
        .addMiddleware(logRequests())
        .addHandler(router.call);

    final server = await shelf_io.serve(handler, '0.0.0.0', 5000);

    print(
      'ERP API server running on '
      'http://${server.address.host}:${server.port}',
    );
  } catch (e) {
    print('Database connection failed: $e');
  }
}
