import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';
import 'app_card.dart';
import 'status_badge.dart';

class AIInsightCard extends StatelessWidget {
  final AIInsight insight;
  final VoidCallback? onAction;

  const AIInsightCard({
    super.key,
    required this.insight,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      hasGoldAccent: true,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatusBadge(
                label: insight.tag,
                type: BadgeType.goldTag,
                customIcon: Icons.psychology_rounded,
              ),
              Row(
                children: [
                  const Icon(Icons.bolt_rounded, size: 14, color: AppColors.accentGold),
                  const SizedBox(width: 2),
                  Text(
                    "On-Device AI",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            insight.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            insight.description,
            style: TextStyle(
              fontSize: 13.5,
              height: 1.4,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          if (insight.potentialSavings > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.protectiveGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.savings_rounded, size: 18, color: AppColors.protectiveGreen),
                  const SizedBox(width: 8),
                  Text(
                    "Est. Savings: ₹${insight.potentialSavings.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.protectiveGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primaryTeal.withValues(alpha: 0.08),
                foregroundColor: AppColors.primaryTeal,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    insight.actionText,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_rounded, size: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
