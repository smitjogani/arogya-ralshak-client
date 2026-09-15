import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum ButtonType { primary, secondary, secondaryGold, emergency, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.fontSize,
    this.padding,
  });


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == ButtonType.secondaryGold
                    ? AppColors.accentGold
                    : Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSize ?? 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
              color: _getTextColor(isDark),
            ),
          ),
        ),
      ],
    );

    EdgeInsetsGeometry defaultPadding;
    switch (type) {
      case ButtonType.emergency:
        defaultPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
        break;
      case ButtonType.text:
        defaultPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
        break;
      default:
        defaultPadding = const EdgeInsets.symmetric(horizontal: 18, vertical: 14);
        break;
    }

    final effectivePadding = padding ?? defaultPadding;

    Widget container;
    switch (type) {
      case ButtonType.primary:
        container = Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [AppColors.primaryLightTeal, AppColors.primaryTeal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x290D7377),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: effectivePadding,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: buttonChild,
          ),
        );
        break;

      case ButtonType.secondary:
        container = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryTeal,
            side: const BorderSide(color: AppColors.primaryTeal, width: 1.5),
            padding: effectivePadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: buttonChild,
        );
        break;

      case ButtonType.secondaryGold:
        container = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.accentGold,
            side: const BorderSide(color: AppColors.accentGold, width: 2),
            padding: effectivePadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: buttonChild,
        );
        break;


      case ButtonType.emergency:
        container = Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [AppColors.emergencyRed, Color(0xFFC02633)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40E63946),
                blurRadius: 16,
                spreadRadius: 2,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: effectivePadding,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: buttonChild,
          ),
        );
        break;

      case ButtonType.text:
        container = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryTeal,
            padding: effectivePadding,
          ),
          child: buttonChild,
        );
        break;
    }

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: container);
    }

    return container;
  }

  Color _getTextColor(bool isDark) {
    switch (type) {
      case ButtonType.primary:
      case ButtonType.emergency:
        return Colors.white;
      case ButtonType.secondary:
        return AppColors.primaryTeal;
      case ButtonType.secondaryGold:
        return AppColors.accentGold;
      case ButtonType.text:
        return isDark ? AppColors.accentGold : AppColors.primaryTeal;
    }
  }

}
