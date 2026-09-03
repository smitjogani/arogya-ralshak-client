import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final bool hasGoldAccent;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 20.0,
    this.hasGoldAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final cardBg = backgroundColor ?? (isDark ? AppColors.cardDark : AppColors.cardLight);
    final border = borderColor ?? (hasGoldAccent 
        ? AppColors.accentGold.withValues(alpha: 0.6) 
        : (isDark ? AppColors.borderDark : AppColors.borderLight));

    Widget content = Container(
      padding: padding ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: border,
          width: hasGoldAccent ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: hasGoldAccent 
                ? AppColors.accentGold.withValues(alpha: 0.12)
                : (isDark ? Colors.black26 : AppColors.shadowColor),
            blurRadius: hasGoldAccent ? 14 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: content,
        ),
      );
    }

    return content;
  }
}
