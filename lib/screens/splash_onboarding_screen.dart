import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../widgets/app_logo.dart';
import '../widgets/custom_button.dart';
import '../widgets/responsive_layout.dart';
import 'auth/auth_screen.dart';
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

  void _proceedToAuth() {
    Get.to(() => const AuthScreen());
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWide = ResponsiveLayout.isWide(context);

    return Scaffold(
      body: SafeArea(
        child: ResponsiveCenter(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: isWide
                  ? _buildWideHeroLayout(context, isDark)
                  : _buildMobileLayout(context, isDark),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, bool isDark) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              // App Logo & Shield Vector
              const AppLogo(size: 120, animate: true),
              const SizedBox(height: 24),

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
              const SizedBox(height: 28),

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
              const SizedBox(height: 28),

              // Buttons
              CustomButton(
                text: "Get Started",
                icon: Icons.arrow_forward_rounded,
                onPressed: _proceedToApp,
                type: ButtonType.primary,
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: "Sign In to Account",
                onPressed: _proceedToAuth,
                type: ButtonType.secondaryGold,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWideHeroLayout(BuildContext context, bool isDark) {
    return Center(
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Hero & Branding Column
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppLogo(size: 110, animate: true),
                  const SizedBox(height: 24),
                  Text(
                    "Aarogya-Rakshak",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.primaryTeal,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 18),
                  Text(
                    "On-Device AI for Medical Emergency Financial Clarity",
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: "Get Started",
                          icon: Icons.arrow_forward_rounded,
                          onPressed: _proceedToApp,
                          type: ButtonType.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: "Sign In",
                          onPressed: _proceedToAuth,
                          type: ButtonType.secondaryGold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 48),

            // Right Features Column
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHighlightItem(
                    isDark,
                    icon: Icons.lock_rounded,
                    title: "100% On-Device & Private",
                    subtitle: "Zero medical or financial data leaves your phone.",
                    accentColor: AppColors.primaryTeal,
                  ),
                  const SizedBox(height: 16),
                  _buildHighlightItem(
                    isDark,
                    icon: Icons.bolt_rounded,
                    title: "Instant Emergency Cost Clarity",
                    subtitle: "Know cashless estimates & out-of-pocket range in 1-tap.",
                    accentColor: AppColors.accentGold,
                  ),
                  const SizedBox(height: 16),
                  _buildHighlightItem(
                    isDark,
                    icon: Icons.local_hospital_rounded,
                    title: "Offline Emergency Guidance",
                    subtitle: "Full capabilities even without internet or network.",
                    accentColor: AppColors.protectiveGreen,
                  ),
                ],
              ),
            ),
          ],
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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
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
