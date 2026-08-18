import 'package:flutter/material.dart';

import '../models/branch_model.dart';
import 'branch_actions_menu.dart';
import 'status_badge.dart';

class BranchDataTable extends StatelessWidget {
  final List<BranchModel> branches;

  const BranchDataTable({super.key, required this.branches});

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade700,
      fontSize: 13,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              SizedBox(width: 70, child: Text('Code', style: headerStyle)),
              Expanded(flex: 3, child: Text('Branch Name', style: headerStyle)),
              Expanded(flex: 3, child: Text('City & State', style: headerStyle)),
              Expanded(flex: 3, child: Text('Contact', style: headerStyle)),
              SizedBox(width: 90, child: Text('Status', style: headerStyle)),
              const SizedBox(width: 60, child: Text('')),
            ],
          ),
        ),
        const Divider(height: 1),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: branches.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final b = branches[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 70,
                    child: Text(
                      b.code,
                      style: const TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(b.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 14, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                b.address,
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text('${b.city}, ${b.state}'),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.phone_outlined, size: 14, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text(b.phone, style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.email_outlined, size: 14, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                b.email,
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 90, child: StatusBadge(isActive: b.isActive)),
                  SizedBox(width: 60, child: BranchActionsMenu(branch: b)),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}