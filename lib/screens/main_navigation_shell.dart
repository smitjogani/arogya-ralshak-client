import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/app_logo.dart';
import '../widgets/responsive_layout.dart';
import 'emergency/emergency_mode_screen.dart';
import 'finances/finances_clarity_screen.dart';
import 'home/home_dashboard_screen.dart';
import 'profile/profile_settings_screen.dart';

class MainNavigationShell extends StatelessWidget {
  const MainNavigationShell({super.key});

  static final List<Widget> _screens = [
    const HomeDashboardScreen(),
    const EmergencyModeScreen(),
    const FinancesClarityScreen(),
    const ProfileSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWide = ResponsiveLayout.isWide(context);

    return Obx(() {
      final int currentIndex = controller.currentTab.value;
      final bool isEmergencyActive = controller.isEmergencyActive.value;

      if (isWide) {
        // Desktop / Tablet Layout with Left Side Navigation Drawer / NavigationRail
        return Scaffold(
          body: Row(
            children: [
              _buildSideNavigationRail(context, controller, isDark, currentIndex, isEmergencyActive),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(
                child: IndexedStack(
                  index: currentIndex,
                  children: _screens,
                ),
              ),
            ],
          ),
        );
      }

      // Mobile Layout with Bottom Navigation Bar
      return Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black38 : AppColors.shadowColor,
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
            border: Border(
              top: BorderSide(
                color: isEmergencyActive
                    ? AppColors.emergencyRed.withValues(alpha: 0.5)
                    : (isDark ? AppColors.borderDark : AppColors.borderLight),
                width: isEmergencyActive ? 2.0 : 1.0,
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context,
                    controller: controller,
                    index: 0,
                    icon: Icons.home_rounded,
                    activeIcon: Icons.home_rounded,
                    label: "Home",
                    isActive: currentIndex == 0,
                  ),
                  _buildEmergencyNavItem(
                    context,
                    controller: controller,
                    index: 1,
                    isActive: currentIndex == 1,
                    isEmergencyActive: isEmergencyActive,
                  ),
                  _buildNavItem(
                    context,
                    controller: controller,
                    index: 2,
                    icon: Icons.account_balance_wallet_outlined,
                    activeIcon: Icons.account_balance_wallet_rounded,
                    label: "Finances",
                    isActive: currentIndex == 2,
                  ),
                  _buildNavItem(
                    context,
                    controller: controller,
                    index: 3,
                    icon: Icons.person_outline_rounded,
                    activeIcon: Icons.person_rounded,
                    label: "Profile",
                    isActive: currentIndex == 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSideNavigationRail(
    BuildContext context,
    AppController controller,
    bool isDark,
    int currentIndex,
    bool isEmergencyActive,
  ) {
    return Container(
      width: 240,
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Logo & Branding
          Row(
            children: [
              const AppLogo(size: 38, animate: false),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Aarogya",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.primaryTeal,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Text(
                      "Rakshak AI",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentGold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Navigation Links
          _buildSideNavItem(
            context,
            controller: controller,
            index: 0,
            icon: Icons.home_rounded,
            label: "Home Dashboard",
            isActive: currentIndex == 0,
          ),
          const SizedBox(height: 8),
          _buildSideEmergencyNavItem(
            context,
            controller: controller,
            index: 1,
            isActive: currentIndex == 1,
            isEmergencyActive: isEmergencyActive,
          ),
          const SizedBox(height: 8),
          _buildSideNavItem(
            context,
            controller: controller,
            index: 2,
            icon: Icons.account_balance_wallet_rounded,
            label: "Finances & Clarity",
            isActive: currentIndex == 2,
          ),
          const SizedBox(height: 8),
          _buildSideNavItem(
            context,
            controller: controller,
            index: 3,
            icon: Icons.person_rounded,
            label: "Profile & AI Engine",
            isActive: currentIndex == 3,
          ),

          const Spacer(),

          // Theme Toggle & On-Device Status Footer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, color: AppColors.protectiveGreen, size: 20),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "On-Device Active",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.protectiveGreen,
                        ),
                      ),
                      Text(
                        "Offline Ready",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    controller.isDarkMode.value ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                    size: 18,
                    color: AppColors.accentGold,
                  ),
                  onPressed: () => controller.toggleTheme(),
                  tooltip: "Toggle Theme",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideNavItem(
    BuildContext context, {
    required AppController controller,
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => controller.changeTab(index),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryTeal.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: isActive
                ? Border.all(color: AppColors.primaryTeal.withValues(alpha: 0.3))
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive
                    ? AppColors.primaryTeal
                    : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive
                      ? (isDark ? Colors.white : AppColors.primaryTeal)
                      : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSideEmergencyNavItem(
    BuildContext context, {
    required AppController controller,
    required int index,
    required bool isActive,
    required bool isEmergencyActive,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => controller.changeTab(index),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            gradient: isEmergencyActive
                ? const LinearGradient(
                    colors: [AppColors.emergencyRed, Color(0xFFC02633)],
                  )
                : (isActive
                    ? const LinearGradient(
                        colors: [AppColors.accentGold, Color(0xFFB5840A)],
                      )
                    : null),
            color: (!isEmergencyActive && !isActive)
                ? AppColors.accentGold.withValues(alpha: 0.1)
                : null,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                Icons.medical_services_rounded,
                color: (isEmergencyActive || isActive) ? Colors.white : AppColors.accentGold,
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                "SOS Emergency",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: (isEmergencyActive || isActive)
                      ? Colors.white
                      : AppColors.accentGold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required AppController controller,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isActive
        ? AppColors.primaryTeal
        : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight);

    return InkWell(
      onTap: () => controller.changeTab(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryTeal.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isActive ? activeIcon : icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyNavItem(
    BuildContext context, {
    required AppController controller,
    required int index,
    required bool isActive,
    required bool isEmergencyActive,
  }) {
    return InkWell(
      onTap: () => controller.changeTab(index),
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: isEmergencyActive
                    ? const LinearGradient(
                        colors: [AppColors.emergencyRed, Color(0xFFC02633)],
                      )
                    : const LinearGradient(
                        colors: [AppColors.accentGold, Color(0xFFB5840A)],
                      ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (isEmergencyActive ? AppColors.emergencyRed : AppColors.accentGold)
                        .withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.medical_services_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "SOS",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 12.5,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Emergency",
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                color: isEmergencyActive
                    ? AppColors.emergencyRed
                    : (isActive ? AppColors.accentGold : AppColors.accentDarkGold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
