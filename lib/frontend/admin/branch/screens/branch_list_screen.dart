import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:erp_software/frontend/admin/branch/models/branch_model.dart';
import 'package:erp_software/frontend/admin/branch/providers/branch_provider.dart';
import 'package:erp_software/frontend/admin/branch/screens/add_branch_screen.dart';
import 'package:erp_software/frontend/admin/branch/screens/edit_branch_screen.dart';
import 'package:erp_software/frontend/admin/branch/widgets/branch_card.dart';
import 'package:erp_software/frontend/admin/branch/widgets/branch_search_bar.dart';

class BranchListScreen extends StatefulWidget {
  const BranchListScreen({super.key});

  @override
  State<BranchListScreen> createState() => _BranchListScreenState();
}

class _BranchListScreenState extends State<BranchListScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BranchProvider>().fetchBranches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Branches'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              context.read<BranchProvider>().fetchBranches();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Consumer<BranchProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.branches.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.hasError && provider.branches.isEmpty) {
            return _ErrorView(
              message: provider.errorMessage!,
              onRetry: provider.fetchBranches,
            );
          }

          final branches = provider.searchBranches(_searchQuery);

          return RefreshIndicator(
            onRefresh: provider.fetchBranches,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    // child: BranchSearchBar(
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _searchQuery = value;
                    //     });
                    //   },
                    // ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${branches.length} Branch${branches.length == 1 ? '' : 'es'}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),

                        ElevatedButton.icon(
                          onPressed: () async {
                            // await Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) =>
                            //         const AddBranchScreen(),
                            //   ),
                            // );

                            if (mounted) {
                              provider.fetchBranches();
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add Branch'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 12),
                ),

                if (branches.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        'No branches found',
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      24,
                    ),
                    // sliver: SliverList(
                    //   delegate: SliverChildBuilderDelegate(
                    //     (context, index) {
                    //       final branch = branches[index];

                    //       return Padding(
                    //         padding: const EdgeInsets.only(
                    //           bottom: 12,
                    //         ),
                    //         child: BranchCard(
                    //           branch: branch,
                    //           onEdit: () async {
                    //             if (branch.id == null) return;

                    //             await Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                 builder: (_) =>
                    //                     EditBranchScreen(
                    //                   branchId: branch.id!,
                    //                 ),
                    //               ),
                    //             );

                    //             if (mounted) {
                    //               provider.fetchBranches();
                    //             }
                    //           },
                    //           onDelete: () {
                    //             _confirmDelete(
                    //               context,
                    //               provider,
                    //               branch,
                    //             );
                    //           },
                    //         ),
                    //       );
                    //     },
                    //     childCount: branches.length,
                    //   ),
                    // ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    BranchProvider provider,
    BranchModel branch,
  ) async {
    if (branch.id == null) return;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Branch'),
          content: Text(
            'Are you sure you want to delete "${branch.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    final success = await provider.deleteBranch(branch.id!);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Branch deleted successfully'
              : provider.errorMessage ??
                  'Failed to delete branch',
        ),
      ),
    );
  }
}

// ============================================================
// ERROR VIEW
// ============================================================

class _ErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

