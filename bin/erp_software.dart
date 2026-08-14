import 'package:erp_software/backend/admin/branch/controllers/branch_controller.dart';
import 'package:erp_software/backend/admin/branch/repositories/branch_repository.dart';
import 'package:erp_software/backend/admin/branch/services/branch_service.dart';
import 'package:erp_software/backend/controller/employee_controller.dart';
import 'package:erp_software/backend/database/postgres_service.dart';
import 'package:erp_software/backend/services/employee_service.dart';
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

    final router = Router();

    // Employee API
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
    final handler = Pipeline()
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
