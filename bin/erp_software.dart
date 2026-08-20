import 'dart:io';

import 'package:erp_software/backend/controllers/auth_controller.dart';
import 'package:erp_software/backend/controllers/employee_controller.dart';
import 'package:erp_software/backend/repositories/auth_repository.dart';
import 'package:erp_software/backend/repositories/employee_repository.dart';
import 'package:erp_software/backend/repositories/otp_repository.dart';
import 'package:erp_software/backend/routes/auth_routes.dart';
import 'package:erp_software/backend/routes/employee_routes.dart';
import 'package:erp_software/backend/services/auth_service.dart';
import 'package:erp_software/backend/services/email_service.dart';
import 'package:erp_software/backend/services/employee_service.dart';
import 'package:erp_software/core/config/app_config.dart';
import 'package:erp_software/core/database/postgres_service.dart';
import 'package:erp_software/backend/controllers/cashier/barcode_controller.dart';
import 'package:erp_software/backend/controllers/cashier/cashier_settings_controller.dart';
import 'package:erp_software/backend/controllers/cashier/order_controller.dart';
import 'package:erp_software/backend/controllers/cashier/pos_controller.dart';
import 'package:erp_software/backend/controllers/cashier/refund_controller.dart';
import 'package:erp_software/backend/repositories/cashier/barcode_repository.dart';
import 'package:erp_software/backend/repositories/cashier/cashier_settings_repository.dart';
import 'package:erp_software/backend/repositories/cashier/order_repository.dart';
import 'package:erp_software/backend/repositories/cashier/product_repository.dart';
import 'package:erp_software/backend/repositories/cashier/refund_repository.dart';
import 'package:erp_software/backend/routes/cashier_routes.dart';
import 'package:erp_software/backend/services/cashier/barcode_service.dart';
import 'package:erp_software/backend/services/cashier/cashier_settings_service.dart';
import 'package:erp_software/backend/services/cashier/order_service.dart';
import 'package:erp_software/backend/services/cashier/pos_service.dart';
import 'package:erp_software/backend/services/cashier/refund_service.dart';

// ---- Admin module (yours) ----
import 'package:erp_software/backend/admin/branch/controllers/branch_controller.dart';
import 'package:erp_software/backend/admin/branch/repositories/branch_repository.dart';
import 'package:erp_software/backend/admin/branch/services/branch_service.dart';
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
import 'package:erp_software/backend/admin/landing_page/controllers/landing_page_controller.dart';
import 'package:erp_software/backend/admin/landing_page/repositories/landing_page_repository.dart';
import 'package:erp_software/backend/admin/landing_page/services/landing_page_service.dart';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

Middleware _corsMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
        });
      }
      final response = await innerHandler(request);
      return response.change(headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
      });
    };
  };
}

Future<void> main() async {
  final db = PostgresService();

  try {
    // 1. Connect PostgreSQL & initialize tables
    await db.connect();

    print('ERP database is ready');

    // 2. Initialize Repositories
    final authRepository = AuthRepository(db);
    final employeeRepository = EmployeeRepository(db);
    final otpRepository = OtpRepository(db);

    // Cashier Repositories
    final productRepository = ProductRepository(db);
    final orderRepository = OrderRepository(db);
    final refundRepository = RefundRepository(db);
    final barcodeRepository = BarcodeRepository(db);
    final cashierSettingsRepository = CashierSettingsRepository(db);

    // 3. Initialize Services
    final emailService = EmailService();
    final authService = AuthService(
      authRepository: authRepository,
      employeeRepository: employeeRepository,
      otpRepository: otpRepository,
      emailService: emailService,
    );
    final employeeService = EmployeeService(
      employeeRepository: employeeRepository,
      authRepository: authRepository,
    );

    // Cashier Services
    final posService = PosService(productRepository);
    final cashierSettingsService = CashierSettingsService(cashierSettingsRepository);
    final orderService = OrderService(
      orderRepository: orderRepository,
      settingsRepository: cashierSettingsRepository,
    );
    final refundService = RefundService(refundRepository);
    final barcodeService = BarcodeService(barcodeRepository);

    // 4. Initialize Controllers
    final authController = AuthController(authService);
    final employeeController = EmployeeController(employeeService);

    // Cashier Controllers
    final posController = PosController(posService);
    final orderController = OrderController(orderService);
    final refundController = RefundController(refundService);
    final barcodeController = BarcodeController(barcodeService);
    final cashierSettingsController = CashierSettingsController(cashierSettingsService);

    // ---- 4b. Admin module (yours) — uses db.connection, same as your repositories expect ----
    final branchRepository = BranchRepository(db.connection);
    final branchService = BranchService(branchRepository);
    final branchController = BranchController(branchService);

    final reportsRepository = ReportsRepository(db.connection);
    final reportsService = ReportsService(reportsRepository);
    final reportsController = ReportsController(reportsService);

    final managerRepository = ManagerRepository(db.connection);
    final managerService = ManagerService(managerRepository);
    final managerController = ManagerController(managerService);

    final auditLogRepository = AuditLogRepository(db.connection);
    final auditLogService = AuditLogService(auditLogRepository);
    final auditLogController = AuditLogController(auditLogService);

    final settingsRepository = SettingsRepository(db.connection);
    final settingsService = SettingsService(settingsRepository);
    final settingsController = SettingsController(settingsService);

    final landingPageRepository = LandingPageRepository(db.connection);
    final landingPageService = LandingPageService(landingPageRepository);
    final landingPageController = LandingPageController(landingPageService);

    // 5. Mount Sub-Routers
    final mainRouter = Router();
    mainRouter.mount('/api/auth', setupAuthRoutes(authController).call);
    mainRouter.mount('/api/employees', setupEmployeeRoutes(employeeController).call);
    mainRouter.mount(
      '/api/cashier',
      setupCashierRoutes(
        posController: posController,
        orderController: orderController,
        refundController: refundController,
        barcodeController: barcodeController,
        settingsController: cashierSettingsController,
      ).call,
    );

    // ---- 5b. Admin routes (yours) — flat, same exact paths your Flutter app already calls ----
    mainRouter.post('/admin/branches', branchController.createBranch);
    mainRouter.get('/admin/branches', branchController.getBranches);
    mainRouter.get('/admin/branches/<id>', branchController.getBranchById);
    mainRouter.put('/admin/branches/<id>', branchController.updateBranch);
    mainRouter.delete('/admin/branches/<id>', branchController.deleteBranch);

    mainRouter.get('/admin/reports/sales', reportsController.getSalesReport);
    mainRouter.get('/admin/reports/customers', reportsController.getCustomers);
    mainRouter.get('/admin/reports/purchases', reportsController.getPurchaseReport);
    mainRouter.get('/admin/reports/suppliers', reportsController.getSuppliers);
    mainRouter.get('/admin/reports/inventory', reportsController.getInventoryReport);
    mainRouter.get('/admin/reports/categories', reportsController.getCategories);

    mainRouter.post('/admin/managers', managerController.createManager);
    mainRouter.get('/admin/managers', managerController.getManagers);
    mainRouter.get('/admin/managers/<id>', managerController.getManagerById);
    mainRouter.put('/admin/managers/<id>', managerController.updateManager);
    mainRouter.delete('/admin/managers/<id>', managerController.deleteManager);

    mainRouter.get('/admin/audit-logs', auditLogController.getLogs);
    mainRouter.get('/admin/audit-logs/employee/<id>', auditLogController.getEmployeeTimeline);

    mainRouter.get('/admin/settings', settingsController.getSettings);
    mainRouter.put('/admin/settings', settingsController.updateSettings);
    mainRouter.post('/admin/settings/reset', settingsController.resetSettings);

    mainRouter.get('/admin/landing-page', landingPageController.getSettings);
    mainRouter.put('/admin/landing-page', landingPageController.updateSettings);
    mainRouter.post('/admin/landing-page/reset', landingPageController.resetSettings);

    // 6. Middleware Pipeline
    final handler = Pipeline()
        .addMiddleware(_corsMiddleware())
        .addMiddleware(logRequests())
        .addHandler(mainRouter.call);

    final port = AppConfig.apiPort;
    final server = await shelf_io.serve(handler, '0.0.0.0', port, shared: true);

    stdout.writeln('ERP REST API Server running on http://${server.address.host}:${server.port}');
  } catch (e) {
    stderr.writeln('ERP Backend initialization error: $e');
  }
}