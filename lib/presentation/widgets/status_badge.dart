import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/loan_request.dart';

class StatusBadge extends StatelessWidget {
  final LoanStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    Color border;
    IconData icon;

    switch (status) {
      case LoanStatus.pending:
        bg = AppColors.warningLight;
        text = const Color(0xFFB45309);
        border = const Color(0xFFFDE68A);
        icon = Icons.hourglass_top_rounded;
        break;
      case LoanStatus.approved:
        bg = AppColors.infoLight;
        text = const Color(0xFF0369A1);
        border = const Color(0xFFBAE6FD);
        icon = Icons.check_circle_outline_rounded;
        break;
      case LoanStatus.borrowed:
        bg = const Color(0xFFEDE9FE);
        text = const Color(0xFF6D28D9);
        border = const Color(0xFFDDD6FE);
        icon = Icons.inventory_2_outlined;
        break;
      case LoanStatus.returned:
        bg = AppColors.successLight;
        text = const Color(0xFF15803D);
        border = const Color(0xFFBBF7D0);
        icon = Icons.assignment_turned_in_rounded;
        break;
      case LoanStatus.rejected:
        bg = AppColors.dangerLight;
        text = const Color(0xFFB91C1C);
        border = const Color(0xFFFECACA);
        icon = Icons.cancel_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: text),
          const SizedBox(width: 5),
          Text(
            status.label,
            style: TextStyle(
              color: text,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class StockBadge extends StatelessWidget {
  final int available;
  final int total;

  const StockBadge({
    super.key,
    required this.available,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOut = available <= 0;
    final bool isLow = !isOut && (available / total) < 0.25;

    final Color bg = isOut
        ? AppColors.dangerLight
        : isLow
            ? AppColors.warningLight
            : AppColors.successLight;

    final Color textColor = isOut
        ? AppColors.danger
        : isLow
            ? const Color(0xFFB45309)
            : const Color(0xFF15803D);

    final String text = isOut
        ? 'Stok Habis'
        : isLow
            ? 'Stok Menipis ($available unit)'
            : 'Tersedia: $available unit';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: textColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
