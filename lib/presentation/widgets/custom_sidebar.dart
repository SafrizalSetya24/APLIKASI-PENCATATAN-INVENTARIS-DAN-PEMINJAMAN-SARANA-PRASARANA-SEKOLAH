import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'school_header.dart';

class CustomSidebar extends StatelessWidget {
  final UserRole currentRole;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final int pendingApprovalCount;

  const CustomSidebar({
    super.key,
    required this.currentRole,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.pendingApprovalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: AppColors.sidebarBg,
      ),
      child: Column(
        children: [
          // Sidebar Header Brand
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(Icons.inventory, color: Colors.black87, size: 22),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'SARPRAS WEB',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'SMK Muh. Kramat',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white12, height: 1),

          const SizedBox(height: 16),

          // Role indicator banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  Icon(
                    currentRole == UserRole.admin
                        ? Icons.security_rounded
                        : Icons.school_rounded,
                    color: AppColors.secondary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      currentRole == UserRole.admin
                          ? 'Panel Petugas Sarpras'
                          : 'Panel Siswa & Peminjam',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Menu Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                currentRole == UserRole.borrower ? 'MENU PEMINJAM' : 'MENU ADMINISTRATOR',
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: currentRole == UserRole.borrower
                  ? [
                      _SidebarMenuItem(
                        icon: Icons.grid_view_rounded,
                        title: 'Katalog Sarpras',
                        subtitle: 'Ketersediaan fasilitas',
                        isSelected: selectedIndex == 0,
                        onTap: () => onItemSelected(0),
                      ),
                      _SidebarMenuItem(
                        icon: Icons.qr_code_scanner_rounded,
                        title: 'Scan Barcode',
                        subtitle: 'Peminjaman cepat barang',
                        isSelected: selectedIndex == 1,
                        onTap: () => onItemSelected(1),
                      ),
                      _SidebarMenuItem(
                        icon: Icons.receipt_long_rounded,
                        title: 'Riwayat Pinjaman',
                        subtitle: 'Status pengajuan saya',
                        isSelected: selectedIndex == 2,
                        onTap: () => onItemSelected(2),
                      ),
                    ]
                  : [
                      _SidebarMenuItem(
                        icon: Icons.dashboard_outlined,
                        title: 'Dashboard Sarpras',
                        subtitle: 'Ringkasan & statistik',
                        isSelected: selectedIndex == 0,
                        onTap: () => onItemSelected(0),
                      ),
                      _SidebarMenuItem(
                        icon: Icons.notification_important_outlined,
                        title: 'Persetujuan Peminjaman',
                        subtitle: 'Verifikasi permintaan',
                        badgeCount: pendingApprovalCount,
                        isSelected: selectedIndex == 1,
                        onTap: () => onItemSelected(1),
                      ),
                      _SidebarMenuItem(
                        icon: Icons.inventory_2_outlined,
                        title: 'Master Inventaris',
                        subtitle: 'Data barang & barcode',
                        isSelected: selectedIndex == 2,
                        onTap: () => onItemSelected(2),
                      ),
                    ],
            ),
          ),

          // School Partner Info Card at bottom
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.verified, color: AppColors.secondary, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Mitra Capstone',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'SMK Muhammadiyah Kramat\nKabupaten Tegal, Jawa Tengah',
                  style: TextStyle(color: Colors.white60, fontSize: 11, height: 1.3),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Versi Web 1.0 (Capstone)',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final int badgeCount;

  const _SidebarMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? Colors.white : Colors.white70,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.85),
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: isSelected ? Colors.white70 : Colors.white38,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ),
                if (badgeCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
