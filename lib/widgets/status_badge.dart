import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum BadgeType { onDevice, cashless, covered, pending, alert, goldTag }

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeType type;
  final IconData? customIcon;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = BadgeType.onDevice,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;

    switch (type) {
      case BadgeType.onDevice:
        bg = AppColors.primaryTeal.withValues(alpha: 0.12);
        fg = AppColors.primaryTeal;
        icon = customIcon ?? Icons.lock_outline_rounded;
        break;
      case BadgeType.cashless:
      case BadgeType.covered:
        bg = AppColors.protectiveGreen.withValues(alpha: 0.15);
        fg = AppColors.protectiveGreen;
        icon = customIcon ?? Icons.verified_user_rounded;
        break;
      case BadgeType.pending:
        bg = AppColors.warningOrange.withValues(alpha: 0.15);
        fg = AppColors.warningOrange;
        icon = customIcon ?? Icons.hourglass_top_rounded;
        break;
      case BadgeType.alert:
        bg = AppColors.emergencyRed.withValues(alpha: 0.15);
        fg = AppColors.emergencyRed;
        icon = customIcon ?? Icons.error_outline_rounded;
        break;
      case BadgeType.goldTag:
        bg = AppColors.accentGold.withValues(alpha: 0.18);
        fg = const Color(0xFF9E750B);
        icon = customIcon ?? Icons.auto_awesome_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fg.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: fg),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
