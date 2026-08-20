import 'package:erp_software/backend/controllers/customer_controller.dart';
import 'package:erp_software/backend/controllers/employee_controller.dart';
import 'package:erp_software/backend/controllers/inventory_controller.dart';
import 'package:erp_software/backend/controllers/product_controller.dart';
import 'package:erp_software/backend/controllers/warehouse_controller.dart';

import 'package:erp_software/backend/database/migration_runner.dart';
import 'package:erp_software/backend/database/postgres_service.dart';

import 'package:erp_software/backend/routes/customer_routes.dart';
import 'package:erp_software/backend/routes/employee_routes.dart';
import 'package:erp_software/backend/routes/inventory_routes.dart';
import 'package:erp_software/backend/routes/product_routes.dart';
import 'package:erp_software/backend/routes/warehouse_routes.dart';

import 'package:erp_software/backend/services/customer_service.dart';
import 'package:erp_software/backend/services/employee_service.dart';
import 'package:erp_software/backend/services/inventory_service.dart';
import 'package:erp_software/backend/services/product_service.dart';
import 'package:erp_software/backend/services/warehouse_service.dart';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';


// ============================================================
// CORS
// ============================================================

Middleware corsMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      // Handle browser preflight request
      if (request.method == 'OPTIONS') {
        return Response.ok(
          '',
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods':
                'GET, POST, PUT, DELETE, PATCH, OPTIONS',
            'Access-Control-Allow-Headers':
                'Origin, Content-Type, Accept',
          },
        );
      }

      final response = await handler(request);

      return response.change(
        headers: {
          ...response.headers,
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods':
              'GET, POST, PUT, DELETE, PATCH, OPTIONS',
          'Access-Control-Allow-Headers':
              'Origin, Content-Type, Accept',
        },
      );
    };
  };
}


// ============================================================
// MAIN
// ============================================================

Future<void> main() async {

  // ==========================================================
  // POSTGRESQL
  // ==========================================================

  final postgresService = PostgresService();

  await postgresService.connect();


  // ==========================================================
  // MIGRATIONS
  // ==========================================================

  final migrationRunner = MigrationRunner(
    postgresService,
  );

  await migrationRunner.runMigrations();


  // ==========================================================
  // CUSTOMER
  // ==========================================================

  final customerService = CustomerService(
    postgresService,
  );

  final customerController = CustomerController(
    customerService,
  );


  // ==========================================================
  // INVENTORY
  // ==========================================================

  final inventoryService = InventoryService(
    postgresService,
  );

  final inventoryController = InventoryController(
    inventoryService,
  );

  // ==========================================================
  // PRODUCTS
  // ==========================================================

  final productService = ProductService(postgresService);

  final productController = ProductController(productService);


  final warehouseService = WarehouseService(postgresService);
  final warehouseController = WarehouseController(warehouseService);

  final employeeService = EmployeeService(postgresService);
  final employeeController = EmployeeController(employeeService);
  // ==========================================================
  // ROUTER
  // ==========================================================

  final router = Router();


  // ==========================================================
  // CUSTOMER ROUTES
  // ==========================================================

  router.mount(
    '/',
    customerRoutes(
      customerController,
    ).call,
  );


  // ==========================================================
  // INVENTORY ROUTES
  // ==========================================================

  router.mount(
    '/',
    inventoryRoutes(
      inventoryController,
    ).call,
  );


  // ==========================================================
  // PRODUTS ROUTES
  // ==========================================================

  router.mount('/', productRoutes(productController).call);
  router.mount('/', warehouseRoutes(warehouseController).call);
  router.mount('/', employeeRoutes(employeeController).call);
  // ==========================================================
  // MIDDLEWARE
  // ==========================================================

  final handler = Pipeline()
      .addMiddleware(
        corsMiddleware(),
      )
      .addMiddleware(
        logRequests(),
      )
      .addHandler(
        router.call,
      );


  // ==========================================================
  // SERVER
  // ==========================================================

  final server = await shelf_io.serve(
    handler,
    '0.0.0.0',
    5000,
  );

  print(
    'Server running on http://localhost:${server.port}',
  );
}