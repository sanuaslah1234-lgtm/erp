import 'package:flutter/material.dart';

import '../../branch/widgets/status_badge.dart';
import '../models/manager_model.dart';
import 'manager_actions_menu.dart';

class ManagerDataTable extends StatelessWidget {
  final List<ManagerModel> managers;

  const ManagerDataTable({super.key, required this.managers});

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700, fontSize: 13);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(children: [
            SizedBox(width: 70, child: Text('ID', style: headerStyle)),
            Expanded(flex: 3, child: Text('Manager', style: headerStyle)),
            Expanded(flex: 2, child: Text('Branch', style: headerStyle)),
            Expanded(flex: 3, child: Text('Contact', style: headerStyle)),
            SizedBox(width: 90, child: Text('Status', style: headerStyle)),
            const SizedBox(width: 60, child: Text('')),
          ]),
        ),
        const Divider(height: 1),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: managers.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final m = managers[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 70,
                    child: Text(m.employeeId,
                        style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600)),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: const Color(0xFF6D28D9),
                          child: Text(
                            m.fullName.isNotEmpty ? m.fullName[0].toUpperCase() : '?',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(m.fullName,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      m.branchName != null ? '${m.branchCode} — ${m.branchName}' : 'Unassigned',
                      style: TextStyle(
                        color: m.branchName != null ? null : Colors.grey.shade400,
                        fontStyle: m.branchName != null ? FontStyle.normal : FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.email, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 3),
                        Text(m.phone, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  SizedBox(width: 90, child: StatusBadge(isActive: m.isVerified)),
                  SizedBox(width: 60, child: ManagerActionsMenu(manager: m)),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}