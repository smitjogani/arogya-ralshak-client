import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../widgets/app_logo.dart';
import '../widgets/custom_button.dart';
import 'main_navigation_shell.dart';

class SplashOnboardingScreen extends StatefulWidget {
  const SplashOnboardingScreen({super.key});

  @override
  State<SplashOnboardingScreen> createState() => _SplashOnboardingScreenState();
}

class _SplashOnboardingScreenState extends State<SplashOnboardingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _proceedToApp() {
    Get.offAll(() => const MainNavigationShell());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  // App Logo & Shield Vector
                  const AppLogo(size: 130, animate: true),
                  const SizedBox(height: 28),
                  
                  // App Title
                  Text(
                    "Aarogya-Rakshak",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.primaryTeal,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Pill Tagline
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accentGold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shield_outlined, size: 14, color: AppColors.accentGold),
                        SizedBox(width: 6),
                        Text(
                          "ON-DEVICE MEDICAL AI",
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: Color(0xFF9E750B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Main Tagline
                  Text(
                    "On-Device AI for Medical Emergency Financial Clarity",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Highlights Cards
                  _buildHighlightItem(
                    isDark,
                    icon: Icons.lock_rounded,
                    title: "100% On-Device & Private",
                    subtitle: "Zero medical or financial data leaves your phone.",
                    accentColor: AppColors.primaryTeal,
                  ),
                  const SizedBox(height: 12),
                  _buildHighlightItem(
                    isDark,
                    icon: Icons.bolt_rounded,
                    title: "Instant Emergency Cost Clarity",
                    subtitle: "Know cashless estimates & out-of-pocket range in 1-tap.",
                    accentColor: AppColors.accentGold,
                  ),
                  const SizedBox(height: 12),
                  _buildHighlightItem(
                    isDark,
                    icon: Icons.local_hospital_rounded,
                    title: "Offline Emergency Guidance",
                    subtitle: "Full capabilities even without internet or network.",
                    accentColor: AppColors.protectiveGreen,
                  ),

                  const Spacer(flex: 2),

                  // Buttons
                  CustomButton(
                    text: "Get Started",
                    icon: Icons.arrow_forward_rounded,
                    onPressed: _proceedToApp,
                    type: ButtonType.primary,
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: "I already have an account",
                    onPressed: _proceedToApp,
                    type: ButtonType.secondaryGold,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightItem(
    bool isDark, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
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
