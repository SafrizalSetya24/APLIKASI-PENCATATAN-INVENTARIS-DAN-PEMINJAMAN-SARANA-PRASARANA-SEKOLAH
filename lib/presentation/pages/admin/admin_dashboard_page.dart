import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/inventory_item.dart';
import '../../../core/models/loan_request.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/status_badge.dart';

class AdminDashboardPage extends StatelessWidget {
  final List<InventoryItem> items;
  final List<LoanRequest> loanRequests;
  final VoidCallback onGoToApprovals;
  final Function(LoanRequest request, bool approve) onQuickDecision;

  const AdminDashboardPage({
    super.key,
    required this.items,
    required this.loanRequests,
    required this.onGoToApprovals,
    required this.onQuickDecision,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 800;

    // Computations
    final totalAsetCount = items.fold<int>(0, (sum, i) => sum + i.totalStock);
    final availableAsetCount = items.fold<int>(0, (sum, i) => sum + i.availableStock);
    final borrowedAsetCount = items.fold<int>(0, (sum, i) => sum + i.borrowedStock);
    final pendingRequests =
        loanRequests.where((r) => r.status == LoanStatus.pending).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 14.0 : 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard Administrator Sarpras',
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Inventaris, notifikasi & verifikasi persetujuan',
                      style: TextStyle(fontSize: isMobile ? 11.5 : 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              if (!isMobile)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.today, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(DateTime.now()),
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 18),

          // Stat Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              int cols = 4;
              double ratio = 2.0;
              if (constraints.maxWidth < 600) {
                cols = 2;
                ratio = 1.4;
              } else if (constraints.maxWidth < 950) {
                cols = 2;
                ratio = 1.9;
              }

              return GridView.count(
                crossAxisCount: cols,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: ratio,
                children: [
                  StatCard(
                    title: 'Total Aset',
                    value: '$totalAsetCount',
                    subtitle: '${items.length} jenis fasilitas',
                    icon: Icons.inventory_2_rounded,
                    color: AppColors.primary,
                    bgLight: AppColors.primaryLight,
                  ),
                  StatCard(
                    title: 'Tersedia',
                    value: '$availableAsetCount',
                    subtitle: 'Siap dipinjam',
                    icon: Icons.check_circle_rounded,
                    color: AppColors.success,
                    bgLight: AppColors.successLight,
                  ),
                  StatCard(
                    title: 'Menunggu',
                    value: '${pendingRequests.length}',
                    subtitle: 'Perlu verifikasi',
                    icon: Icons.pending_actions_rounded,
                    color: AppColors.warning,
                    bgLight: AppColors.warningLight,
                    onTap: onGoToApprovals,
                  ),
                  StatCard(
                    title: 'Dipinjam',
                    value: '$borrowedAsetCount',
                    subtitle: 'Fasilitas aktif',
                    icon: Icons.assignment_return_rounded,
                    color: AppColors.info,
                    bgLight: AppColors.infoLight,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 18),

          // Action Required Banner if pending requests exist
          if (pendingRequests.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.notifications_active, color: Color(0xFFD97706), size: 22),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${pendingRequests.length} Pengajuan Menunggu Persetujuan!',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(0xFF92400E),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${pendingRequests.first.borrowerName} meminjam ${pendingRequests.first.quantity} unit ${pendingRequests.first.itemName}',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF78350F)),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: onGoToApprovals,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD97706),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: const Text('Buka Antrean Persetujuan'),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.warning,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.notifications_active, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pemberitahuan: Ada ${pendingRequests.length} Pengajuan Peminjaman Menunggu Persetujuan!',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF92400E),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Pengajuan terbaru: ${pendingRequests.first.borrowerName} meminjam ${pendingRequests.first.quantity} unit ${pendingRequests.first.itemName}',
                                style: const TextStyle(fontSize: 12, color: Color(0xFF78350F)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: onGoToApprovals,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD97706),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Buka Antrean Persetujuan'),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 18),
          ],

          // Table of Recent Requests & Stock Summary (Stacked on Mobile, Row on Desktop)
          if (isMobile) ...[
            _buildRecentRequestsCard(context),
            const SizedBox(height: 18),
            _buildStockSummaryCard(context),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _buildRecentRequestsCard(context)),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: _buildStockSummaryCard(context)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecentRequestsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Aktivitas Pengajuan Terbaru',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Permohonan sarpras dari siswa & guru',
                      style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: onGoToApprovals,
                  icon: const Icon(Icons.arrow_forward, size: 15),
                  label: const Text('Semua'),
                ),
              ],
            ),
            const Divider(height: 20),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: loanRequests.take(5).length,
              separatorBuilder: (context, index) => const Divider(height: 14),
              itemBuilder: (context, index) {
                final req = loanRequests[index];
                final isPending = req.status == LoanStatus.pending;

                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.person, size: 18, color: AppColors.primary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            req.borrowerName,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                          ),
                          Text(
                            '${req.quantity}x ${req.itemName}',
                            style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(status: req.status),
                    if (isPending) ...[
                      const SizedBox(width: 6),
                      IconButton(
                        icon: const Icon(Icons.check, color: AppColors.success, size: 18),
                        tooltip: 'Setujui',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => onQuickDecision(req, true),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.danger, size: 18),
                        tooltip: 'Tolak',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => onQuickDecision(req, false),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockSummaryCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Status Stok Fasilitas Utama',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Ringkasan inventaris sekolah',
              style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
            ),
            const Divider(height: 20),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.take(6).length,
              separatorBuilder: (context, index) => const Divider(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${item.availableStock} / ${item.totalStock}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: item.availabilityPercentage,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          item.availableStock > 0 ? AppColors.primary : AppColors.danger,
                        ),
                        minHeight: 5,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
