import 'package:flutter/material.dart';

import '../models/branch_model.dart';
import 'branch_actions_menu.dart';
import 'status_badge.dart';

class BranchCardList extends StatelessWidget {
  final List<BranchModel> branches;

  const BranchCardList({super.key, required this.branches});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: branches.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final b = branches[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      b.code,
                      style: const TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  StatusBadge(isActive: b.isActive),
                  BranchActionsMenu(branch: b),
                ],
              ),
              const SizedBox(height: 8),
              Text(b.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${b.address} · ${b.city}, ${b.state}',
                      style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.phone_outlined, size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(b.phone, style: const TextStyle(fontSize: 13)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.email_outlined, size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(b.email,
                        style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}