import 'package:flutter/material.dart';
import 'package:erp_software/frontend/models/employee_model.dart';
import 'package:erp_software/frontend/screens/employee/edit_employee_screen.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  final EmployeeModel employee;

  const EmployeeDetailsScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final user = employee.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(employee.fullName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditEmployeeScreen(employee: employee),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF6C5CE7).withValues(alpha: 0.15),
                    child: Text(
                      employee.fullName.isNotEmpty ? employee.fullName[0].toUpperCase() : 'E',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF6C5CE7)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    employee.fullName,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C5CE7).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'ID: ${employee.employeeId}',
                      style: const TextStyle(color: Color(0xFF6C5CE7), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDetailRow(Icons.email_outlined, 'Email', user?.email ?? 'N/A'),
                    const Divider(),
                    _buildDetailRow(Icons.security_outlined, 'Role', (user?.role ?? 'employee').toUpperCase()),
                    const Divider(),
                    _buildDetailRow(Icons.phone_outlined, 'Phone', employee.phone ?? 'N/A'),
                    const Divider(),
                    _buildDetailRow(Icons.business_outlined, 'Department', employee.department ?? 'N/A'),
                    const Divider(),
                    _buildDetailRow(Icons.work_outlined, 'Designation', employee.designation ?? 'N/A'),
                    const Divider(),
                    _buildDetailRow(Icons.calendar_today_outlined, 'Joining Date', employee.joiningDate ?? 'N/A'),
                    const Divider(),
                    _buildDetailRow(
                      Icons.toggle_on_outlined,
                      'Account Status',
                      (user?.isActive ?? true) ? 'Active' : 'Deactivated',
                      color: (user?.isActive ?? true) ? Colors.green : Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF6C5CE7)),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
