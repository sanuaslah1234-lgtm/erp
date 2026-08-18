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
