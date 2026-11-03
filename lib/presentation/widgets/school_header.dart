import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

enum UserRole {
  borrower('Mode Peminjam (Siswa/Guru)'),
  admin('Mode Admin Sarpras');

  final String label;
  const UserRole(this.label);
}

class SchoolHeader extends StatelessWidget {
  final UserRole currentRole;
  final ValueChanged<UserRole> onRoleChanged;
  final VoidCallback onScanBarcodePressed;
  final int pendingNotificationCount;
  final VoidCallback onNotificationsPressed;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onMenuPressed;

  const SchoolHeader({
    super.key,
    required this.currentRole,
    required this.onRoleChanged,
    required this.onScanBarcodePressed,
    required this.pendingNotificationCount,
    required this.onNotificationsPressed,
    this.onSearchChanged,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1024;
    final bool isMobile = screenWidth < 640;

    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // Hamburger button for Mobile / Tablet drawer
          if (!isDesktop) ...[
            IconButton(
              icon: const Icon(Icons.menu, color: AppColors.textPrimary),
              onPressed: onMenuPressed,
              tooltip: 'Buka Menu',
            ),
            const SizedBox(width: 4),
          ],

          // Brand / School Identity
          Container(
            width: isMobile ? 36 : 42,
            height: isMobile ? 36 : 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(Icons.school, color: Colors.white, size: isMobile ? 20 : 24),
            ),
          ),
          const SizedBox(width: 10),

          // Title text (condenses on mobile)
          if (isMobile) ...[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'SMK MUH KRAMAT',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Sarpras Sekolah',
                    style: TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ] else ...[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'SMK MUHAMMADIYAH KRAMAT',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryLight,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4)),
                      ),
                      child: const Text(
                        'SARPRAS',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFB45309),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'Sistem Inventaris & Peminjaman Fasilitas',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],

          // Search Bar (Desktop only)
          if (isDesktop) ...[
            const SizedBox(width: 20),
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 340),
                height: 40,
                child: TextField(
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Cari fasilitas, barcode, ruang...',
                    prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textMuted),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    fillColor: AppColors.surfaceVariant,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ] else if (!isMobile) ...[
            const Spacer(),
          ],

          const SizedBox(width: 8),

          // Quick Scan Barcode Button
          if (!isMobile)
            ElevatedButton.icon(
              onPressed: onScanBarcodePressed,
              icon: const Icon(Icons.qr_code_scanner, size: 17),
              label: Text(isDesktop ? 'Scan Barcode' : 'Scan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
            )
          else
            IconButton.filledTonal(
              onPressed: onScanBarcodePressed,
              icon: const Icon(Icons.qr_code_scanner, size: 20, color: AppColors.primary),
              tooltip: 'Scan Barcode',
            ),

          const SizedBox(width: 6),

          // Role Switcher
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _RoleTabItem(
                  icon: Icons.person_outline,
                  label: isDesktop ? 'Peminjam' : '',
                  isActive: currentRole == UserRole.borrower,
                  onTap: () => onRoleChanged(UserRole.borrower),
                ),
                _RoleTabItem(
                  icon: Icons.admin_panel_settings_outlined,
                  label: isDesktop ? 'Admin' : '',
                  isActive: currentRole == UserRole.admin,
                  onTap: () => onRoleChanged(UserRole.admin),
                ),
              ],
            ),
          ),

          const SizedBox(width: 4),

          // Notification Bell
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: onNotificationsPressed,
                icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary),
                tooltip: 'Notifikasi Persetujuan',
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
              if (pendingNotificationCount > 0)
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AppColors.danger,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '$pendingNotificationCount',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Avatar (Desktop/Tablet)
          if (isDesktop) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 17,
              backgroundColor: currentRole == UserRole.admin
                  ? const Color(0xFF0F766E)
                  : AppColors.primary,
              child: Text(
                currentRole == UserRole.admin ? 'AD' : 'AF',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RoleTabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _RoleTabItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
