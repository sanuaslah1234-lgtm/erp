import 'package:flutter/material.dart';
import 'package:erp_software/frontend/models/employee_model.dart';
import 'package:erp_software/frontend/providers/auth_provider.dart';
import 'package:erp_software/frontend/providers/employee_provider.dart';
import 'package:erp_software/frontend/screens/employee/add_employee_screen.dart';
import 'package:erp_software/frontend/screens/employee/edit_employee_screen.dart';
import 'package:erp_software/frontend/widgets/erp_sidebar.dart';
import 'package:erp_software/frontend/widgets/erp_topbar.dart';
import 'package:provider/provider.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  String _activeTab = 'Employees';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      Provider.of<EmployeeProvider>(context, listen: false).fetchEmployees(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final empProvider = Provider.of<EmployeeProvider>(context);
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: isMobile
          ? Drawer(
              child: ErpSidebar(
                activeItem: _activeTab,
                isDrawer: true,
                onSelect: (item) {
                  setState(() {
                    _activeTab = item;
                  });
                },
              ),
            )
          : null,
      body: Row(
        children: [
          // Fixed Sidebar on Desktop/Tablet
          if (!isMobile)
            ErpSidebar(
              activeItem: _activeTab,
              onSelect: (item) {
                setState(() {
                  _activeTab = item;
                });
              },
            ),

          // Main Responsive Content Area
          Expanded(
            child: Column(
              children: [
                ErpTopbar(
                  onSearchChanged: (val) => empProvider.setSearchQuery(val),
                ),

                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _buildDynamicBodyContent(context, authProvider, empProvider, isMobile),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: isMobile
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddEmployeeScreen()),
                );
              },
              backgroundColor: const Color(0xFF0F172A),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildDynamicBodyContent(
    BuildContext context,
    AuthProvider authProvider,
    EmployeeProvider empProvider,
    bool isMobile,
  ) {
    if (_activeTab == 'Employees') {
      return _buildEmployeeListBody(context, authProvider, empProvider, isMobile);
    } else {
      return _buildGenericModuleBody(_activeTab, isMobile);
    }
  }

  Widget _buildEmployeeListBody(
    BuildContext context,
    AuthProvider authProvider,
    EmployeeProvider empProvider,
    bool isMobile,
  ) {
    final employees = empProvider.filteredEmployees;

    return SingleChildScrollView(
      key: const ValueKey('EmployeesTab'),
      padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Subtitle + Add Employee Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Employees',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage employees, roles and employee information.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isMobile)
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddEmployeeScreen()),
                    );
                  },
                  icon: const Icon(Icons.add, size: 18, color: Colors.white),
                  label: const Text(
                    'Add Employee',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Dynamic Mobile Grid / Responsive Wrap
          if (empProvider.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(60.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (employees.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(60.0),
                child: Column(
                  children: [
                    Icon(Icons.person_search, size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text(
                      'No employees found in database',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            )
          else
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: employees.map((emp) {
                return _buildExactEmployeeCard(context, emp, authProvider.token, isMobile);
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildGenericModuleBody(String moduleName, bool isMobile) {
    return SingleChildScrollView(
      key: ValueKey(moduleName),
      padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            moduleName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Live workspace for $moduleName management.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isMobile ? 24.0 : 48.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 179, 8, 8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                Icon(Icons.dashboard_customize_outlined, size: 48, color: const Color(0xFF2563EB).withValues(alpha: 0.6)),
                const SizedBox(height: 16),
                Text(
                  '$moduleName Dashboard Active',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connected to ERP PostgreSQL Mobile Backend.',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExactEmployeeCard(BuildContext context, EmployeeModel employee, String? token, bool isMobile) {
    final empProvider = Provider.of<EmployeeProvider>(context, listen: false);
    final fullName = employee.fullName.trim().isNotEmpty ? employee.fullName.trim() : 'Unnamed Employee';
    final initials = fullName.length >= 2 ? fullName.substring(0, 2).toUpperCase() : (fullName.isNotEmpty ? fullName.substring(0, 1).toUpperCase() : 'EM');
    final userRole = (employee.user?.role ?? 'Employee').toUpperCase();
    final roleDisplay = userRole[0] + userRole.substring(1).toLowerCase();

    return Container(
      width: isMobile ? double.infinity : 310,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'SA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'EMPLOYEE ID',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade400,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          CircleAvatar(
            radius: 40,
            backgroundColor: const Color(0xFFEBF2FA),
            child: Text(
              initials,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(height: 12),

          Text(
            fullName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            roleDisplay,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                _buildCardInfoRow(Icons.badge_outlined, 'EMPLOYEE ID', employee.employeeId),
                _buildCardInfoRow(Icons.email_outlined, 'EMAIL', employee.user?.email ?? 'N/A'),
                _buildCardInfoRow(Icons.phone_outlined, 'PHONE', employee.phone ?? 'N/A'),
                _buildCardInfoRow(Icons.business_outlined, 'BRANCH', employee.department ?? 'N/A'),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF16A34A),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      employee.isVerified ? 'Verified' : 'Pending',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: employee.isVerified ? const Color(0xFF16A34A) : Colors.orange,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF94A3B8)),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EditEmployeeScreen(employee: employee)),
                        );
                      },
                    ),
                    const SizedBox(width: 14),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFF94A3B8)),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        if (employee.id != null) {
                          empProvider.deleteEmployee(token, employee.id!);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade400),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade400,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
