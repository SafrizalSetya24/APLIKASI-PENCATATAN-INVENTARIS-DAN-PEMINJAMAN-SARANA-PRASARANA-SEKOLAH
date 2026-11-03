import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/loan_request.dart';
import '../../widgets/status_badge.dart';

class LoanApprovalsPage extends StatefulWidget {
  final List<LoanRequest> loanRequests;
  final Function(LoanRequest request, LoanStatus newStatus, String? note) onUpdateRequestStatus;

  const LoanApprovalsPage({
    super.key,
    required this.loanRequests,
    required this.onUpdateRequestStatus,
  });

  @override
  State<LoanApprovalsPage> createState() => _LoanApprovalsPageState();
}

class _LoanApprovalsPageState extends State<LoanApprovalsPage> {
  String _selectedTab = 'Menunggu Persetujuan';

  void _showApprovalDialog(LoanRequest request, bool isApprove) {
    final noteController = TextEditingController(
      text: isApprove
          ? 'Disetujui oleh Petugas Sarpras. Harap ambil di ruang sarpras sesuai jadwal.'
          : 'Mohon maaf, permohonan ditolak karena fasilitas sedang digunakan untuk agenda sekolah.',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(
                isApprove ? Icons.check_circle_outline : Icons.cancel_outlined,
                color: isApprove ? AppColors.success : AppColors.danger,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isApprove ? 'Setujui Pengajuan' : 'Tolak Pengajuan',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Peminjam: ${request.borrowerName} (${request.borrowerRole})',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                'Barang: ${request.quantity} unit ${request.itemName}',
                style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 14),
              const Text(
                'Catatan Petugas Sarpras (Opsional):',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: noteController,
                maxLines: 3,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: isApprove
                      ? 'Tulis catatan serah terima barang...'
                      : 'Tuliskan alasan penolakan...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isApprove ? AppColors.success : AppColors.danger,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                widget.onUpdateRequestStatus(
                  request,
                  isApprove ? LoanStatus.approved : LoanStatus.rejected,
                  noteController.text.trim(),
                );
              },
              child: Text(isApprove ? 'Ya, Setujui' : 'Ya, Tolak'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 768;
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');

    final pendingCount =
        widget.loanRequests.where((r) => r.status == LoanStatus.pending).length;

    // Filter
    final filtered = widget.loanRequests.where((req) {
      if (_selectedTab == 'Semua') return true;
      if (_selectedTab == 'Menunggu Persetujuan') return req.status == LoanStatus.pending;
      if (_selectedTab == 'Disetujui') return req.status == LoanStatus.approved;
      if (_selectedTab == 'Sedang Dipinjam') return req.status == LoanStatus.borrowed;
      if (_selectedTab == 'Selesai Dikembalikan') return req.status == LoanStatus.returned;
      if (_selectedTab == 'Ditolak') return req.status == LoanStatus.rejected;
      return true;
    }).toList();

    return Padding(
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
                      'Persetujuan Peminjaman Sarpras',
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Verifikasi permohonan fasilitas SMK Muhammadiyah Kramat',
                      style: TextStyle(fontSize: isMobile ? 11.5 : 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              if (!isMobile && pendingCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.warningLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active, color: AppColors.warning, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '$pendingCount Menunggu',
                        style: const TextStyle(
                          color: Color(0xFFB45309),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Tabs Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _TabButton(
                  title: 'Menunggu Persetujuan',
                  badge: pendingCount > 0 ? '$pendingCount' : null,
                  isSelected: _selectedTab == 'Menunggu Persetujuan',
                  onTap: () => setState(() => _selectedTab = 'Menunggu Persetujuan'),
                ),
                _TabButton(
                  title: 'Disetujui',
                  isSelected: _selectedTab == 'Disetujui',
                  onTap: () => setState(() => _selectedTab = 'Disetujui'),
                ),
                _TabButton(
                  title: 'Sedang Dipinjam',
                  isSelected: _selectedTab == 'Sedang Dipinjam',
                  onTap: () => setState(() => _selectedTab = 'Sedang Dipinjam'),
                ),
                _TabButton(
                  title: 'Selesai Dikembalikan',
                  isSelected: _selectedTab == 'Selesai Dikembalikan',
                  onTap: () => setState(() => _selectedTab = 'Selesai Dikembalikan'),
                ),
                _TabButton(
                  title: 'Semua',
                  isSelected: _selectedTab == 'Semua',
                  onTap: () => setState(() => _selectedTab = 'Semua'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Request List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline, size: 54, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        const Text(
                          'Tidak Ada Pengajuan Pada Kategori Ini',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Semua pengajuan telah diproses.',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final req = filtered[index];
                      final isPending = req.status == LoanStatus.pending;
                      final isApproved = req.status == LoanStatus.approved;
                      final isBorrowed = req.status == LoanStatus.borrowed;

                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(isMobile ? 14.0 : 18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Bar
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceVariant,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          req.id,
                                          style: const TextStyle(
                                            fontFamily: 'monospace',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        dateFormat.format(req.requestDate),
                                        style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                                      ),
                                    ],
                                  ),
                                  StatusBadge(status: req.status),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Content Info Grid (Column on Mobile, Row on Desktop)
                              if (isMobile) ...[
                                // Mobile Stack
                                Text(
                                  req.borrowerName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                                ),
                                Text(
                                  '${req.borrowerRole} • ${req.borrowerId}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceVariant,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${req.quantity}x ${req.itemName}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                      Text(
                                        'Barcode: ${req.itemBarcode}',
                                        style: const TextStyle(fontSize: 11.5, fontFamily: 'monospace', color: AppColors.textSecondary),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Jadwal: ${dateFormat.format(req.loanDate)} s/d ${dateFormat.format(req.returnDate)}',
                                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Keperluan: "${req.purpose}"',
                                  style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                                ),
                              ] else ...[
                                // Desktop Row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Informasi Peminjam',
                                            style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            req.borrowerName,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                                          ),
                                          Text(
                                            '${req.borrowerRole} • ${req.borrowerId}',
                                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Keperluan: "${req.purpose}"',
                                            style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Fasilitas yang Diajukan',
                                            style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            req.itemName,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                                          ),
                                          Text(
                                            'Barcode: ${req.itemBarcode}',
                                            style: const TextStyle(
                                              fontSize: 11.5,
                                              fontFamily: 'monospace',
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryLight,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              'Permintaan: ${req.quantity} Unit',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: AppColors.primaryDark,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Jadwal Penggunaan',
                                            style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Ambil: ${dateFormat.format(req.loanDate)}',
                                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            'Kembali: ${dateFormat.format(req.returnDate)}',
                                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.danger),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],

                              // Admin Note if available
                              if (req.adminNote != null && req.adminNote!.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceVariant,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.comment_outlined, size: 15, color: AppColors.textSecondary),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Catatan Verifikasi: ${req.adminNote}',
                                          style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              const SizedBox(height: 12),
                              const Divider(),
                              const SizedBox(height: 6),

                              // Actions
                              Wrap(
                                alignment: WrapAlignment.end,
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  if (isPending) ...[
                                    OutlinedButton.icon(
                                      onPressed: () => _showApprovalDialog(req, false),
                                      icon: const Icon(Icons.close, size: 15, color: AppColors.danger),
                                      label: const Text('Tolak', style: TextStyle(color: AppColors.danger, fontSize: 12.5)),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: AppColors.danger),
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () => _showApprovalDialog(req, true),
                                      icon: const Icon(Icons.check, size: 15),
                                      label: const Text('Setujui Pengajuan', style: TextStyle(fontSize: 12.5)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.success,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      ),
                                    ),
                                  ] else if (isApproved) ...[
                                    ElevatedButton.icon(
                                      onPressed: () => widget.onUpdateRequestStatus(
                                        req,
                                        LoanStatus.borrowed,
                                        'Barang diserahkan kepada peminjam.',
                                      ),
                                      icon: const Icon(Icons.handshake_outlined, size: 15),
                                      label: const Text('Serah Terima Barang', style: TextStyle(fontSize: 12.5)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.info,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      ),
                                    ),
                                  ] else if (isBorrowed) ...[
                                    ElevatedButton.icon(
                                      onPressed: () => widget.onUpdateRequestStatus(
                                        req,
                                        LoanStatus.returned,
                                        'Barang telah dikembalikan lengkap dan dicek.',
                                      ),
                                      icon: const Icon(Icons.assignment_turned_in, size: 15),
                                      label: const Text('Konfirmasi Pengembalian', style: TextStyle(fontSize: 12.5)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      ),
                                    ),
                                  ] else ...[
                                    const Text(
                                      'Pengajuan selesai diproses.',
                                      style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final String? badge;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    this.badge,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
          ),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : AppColors.danger,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.primary : Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
