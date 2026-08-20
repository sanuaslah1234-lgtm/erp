import 'package:erp_software/backend/controllers/employee_controller.dart';
import 'package:erp_software/backend/middleware/auth_middleware.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Router setupEmployeeRoutes(EmployeeController employeeController) {
  final router = Router();

  // Protect all employee routes with JWT auth middleware
  final pipeline = const Pipeline().addMiddleware(authMiddleware());

  router.post(
    '/',
    pipeline.addHandler((req) => employeeController.createEmployee(req)),
  );
  router.get(
    '/',
    pipeline.addHandler((req) => employeeController.getEmployees(req)),
  );
  router.get(
    '/<id>',
    pipeline.addHandler((req) => employeeController.getEmployeeById(req)),
  );
  router.put(
    '/<id>',
    pipeline.addHandler((req) => employeeController.updateEmployee(req)),
  );
  router.patch(
    '/<id>/status',
    pipeline.addHandler((req) => employeeController.toggleEmployeeStatus(req)),
  );
  router.delete(
    '/<id>',
    pipeline.addHandler((req) => employeeController.deleteEmployee(req)),
  );

  return router;
}
