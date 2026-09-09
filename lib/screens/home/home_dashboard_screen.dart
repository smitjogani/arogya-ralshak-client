import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/app_controller.dart';
import '../../models/models.dart';
import '../../theme/app_colors.dart';
import '../../widgets/ai_insight_card.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/responsive_layout.dart';
import '../../widgets/section_header.dart';
import '../../widgets/status_badge.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWide = ResponsiveLayout.isWide(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const AppLogo(size: 34, animate: false),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Aarogya-Rakshak",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.primaryTeal,
                  ),
                ),
                Text(
                  "On-Device AI Active",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.protectiveGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isDarkMode.value
                    ? Icons.wb_sunny_rounded
                    : Icons.nightlight_round,
                color: AppColors.accentGold,
              ),
              onPressed: () => controller.toggleTheme(),
              tooltip: "Toggle Theme",
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 600));
        },
        child: ResponsiveCenter(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Namaste, Rajesh 👋",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Policy: HDFC ERGO Optima Secure",
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.accentGold.withValues(alpha: 0.4),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: AppColors.accentGold,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "₹10L Cover",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF9E750B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Responsive Top Hero Cards: Side-by-side on wide screens, vertical on mobile
                if (isWide) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildProtectionStatusCard(context, controller, isDark),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildEmergencyTriggerBanner(context, controller),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                ] else ...[
                  _buildProtectionStatusCard(context, controller, isDark),
                  const SizedBox(height: 18),
                  _buildEmergencyTriggerBanner(context, controller),
                  const SizedBox(height: 18),
                ],

                // Privacy Badge ("100% On-Device • No data leaves your phone")
                _buildPrivacyBadge(context, isDark),
                const SizedBox(height: 20),

                // Quick Actions Grid
                SectionHeader(
                  title: "Quick Actions",
                  subtitle: "Manage expenses, coverage & network",
                  icon: Icons.flash_on_rounded,
                ),
                const SizedBox(height: 10),
                _buildQuickActionsGrid(context, controller, isDark),
                const SizedBox(height: 22),

                // AI Financial Insights Highlights
                SectionHeader(
                  title: "AI Clarity Insights",
                  subtitle: "On-device recommendations for savings",
                  actionText: "View All",
                  onActionTap: () => controller.changeTab(2),
                  icon: Icons.auto_awesome_rounded,
                ),
                const SizedBox(height: 10),
                Obx(() {
                  if (controller.aiInsights.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return AIInsightCard(
                    insight: controller.aiInsights.first,
                    onAction: () => controller.changeTab(2),
                  );
                }),
                const SizedBox(height: 22),

                // Recent Activity Section
                SectionHeader(
                  title: "Recent Medical Expenses",
                  subtitle: "Claims & pre-authorizations logged",
                  actionText: "See Finances",
                  onActionTap: () => controller.changeTab(2),
                  icon: Icons.receipt_long_rounded,
                ),
                const SizedBox(height: 10),
                _buildRecentActivityList(context, controller, isDark),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProtectionStatusCard(
    BuildContext context,
    AppController controller,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF143B3D), const Color(0xFF0F2B2D)]
              : [AppColors.primaryTeal, AppColors.primaryDarkTeal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryTeal.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -15,
            child: Icon(
              Icons.shield_rounded,
              size: 110,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const StatusBadge(
                    label: "PROTECTION ACTIVE",
                    type: BadgeType.covered,
                    customIcon: Icons.shield_rounded,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4EFEAA),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Obx(
                        () => Text(
                          controller.isAiModelReady.value
                              ? "AI Online"
                              : "AI Syncing",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4EFEAA),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                "You're Protected",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "On-Device AI actively monitoring your HDFC ERGO cashless network limits & emergency readiness.",
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.4,
                  color: Colors.white.withValues(alpha: 0.88),
                ),
              ),
              const SizedBox(height: 14),
              Divider(color: Colors.white.withValues(alpha: 0.15), height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.memory_rounded,
                        size: 16,
                        color: AppColors.accentGold,
                      ),
                      const SizedBox(width: 6),
                      Obx(
                        () => Text(
                          controller.aiModelVersion.value,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentGold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyTriggerBanner(
    BuildContext context,
    AppController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF261D10), Color(0xFF140D05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.accentGold, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGold.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.accentGold.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.accentGold, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.medical_services_rounded,
                    color: AppColors.accentGold,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            "Emergency Mode",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.bolt_rounded,
                            size: 16,
                            color: AppColors.accentGold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Instant estimates for room rent, cashless hospital network, & out-of-pocket range.",
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: "Activate Emergency Mode",
              icon: Icons.emergency_rounded,
              type: ButtonType.secondaryGold,
              onPressed: () {
                controller.triggerEmergencyMode();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyBadge(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.protectiveGreen.withValues(alpha: 0.3),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.verified_user_rounded,
            color: AppColors.protectiveGreen,
            size: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "100% On-Device AI • No medical or financial data leaves your phone.",
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.protectiveGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(
    BuildContext context,
    AppController controller,
    bool isDark,
  ) {
    final isWide = ResponsiveLayout.isWide(context);
    final isDesktop = ResponsiveLayout.isDesktop(context);

    int crossAxisCount = 2;
    double childAspectRatio = 1.5;
    if (isDesktop) {
      crossAxisCount = 4;
      childAspectRatio = 1.8;
    } else if (isWide) {
      crossAxisCount = 4;
      childAspectRatio = 1.6;
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: childAspectRatio,
      children: [
        _buildActionTile(
          context,
          isDark,
          title: "Add Bill",
          subtitle: "Scan or enter invoice",
          icon: Icons.add_card_rounded,
          iconColor: AppColors.primaryTeal,
          onTap: () => _showAddBillModal(context, controller),
        ),
        _buildActionTile(
          context,
          isDark,
          title: "Check Coverage",
          subtitle: "Procedure cashless search",
          icon: Icons.health_and_safety_rounded,
          iconColor: AppColors.accentGold,
          onTap: () => _showCheckCoverageModal(context, controller),
        ),
        _buildActionTile(
          context,
          isDark,
          title: "AI Insights",
          subtitle: "Savings & guidance",
          icon: Icons.psychology_rounded,
          iconColor: AppColors.protectiveGreen,
          onTap: () => controller.changeTab(2),
        ),
        _buildActionTile(
          context,
          isDark,
          title: "Find Network",
          subtitle: "Cashless hospitals nearby",
          icon: Icons.local_hospital_rounded,
          iconColor: AppColors.infoBlue,
          onTap: () => controller.changeTab(1),
        ),
      ],
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    bool isDark, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.5,
              color: isDark
                  ? AppColors.textMutedDark
                  : AppColors.textMutedLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityList(
    BuildContext context,
    AppController controller,
    bool isDark,
  ) {
    return Obx(() {
      final list = controller.activities.take(3).toList();
      return Column(
        children: list.map((item) {
          BadgeType bType;
          String bText;
          switch (item.status) {
            case ActivityStatus.covered:
              bType = BadgeType.covered;
              bText = "100% Covered";
              break;
            case ActivityStatus.approved:
              bType = BadgeType.cashless;
              bText = "Approved";
              break;
            case ActivityStatus.pending:
              bType = BadgeType.pending;
              bText = "Claim Pending";
              break;
            case ActivityStatus.actionRequired:
              bType = BadgeType.alert;
              bText = "Doc Required";
              break;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: AppCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.receipt_rounded,
                      color: AppColors.primaryTeal,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${item.providerName} • ${item.category}",
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹${item.amount.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      StatusBadge(label: bText, type: bType),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  void _showAddBillModal(BuildContext context, AppController controller) {
    final titleController = TextEditingController();
    final providerController = TextEditingController();
    final amountController = TextEditingController();
    String category = 'Hospitalization';

    Get.bottomSheet(
      ResponsiveCenter(
        maxWidth: 550,
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Add Medical Expense",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Expense Description (e.g. ICU Room Deposit)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: providerController,
                  decoration: InputDecoration(
                    labelText: "Hospital / Provider Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Total Amount (₹)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: "Save & Run On-Device Analysis",
                  icon: Icons.check_circle_rounded,
                  onPressed: () {
                    final amt = double.tryParse(amountController.text) ?? 5000.0;
                    final title = titleController.text.isNotEmpty
                        ? titleController.text
                        : "Medical Expense";
                    final provider = providerController.text.isNotEmpty
                        ? providerController.text
                        : "Local Healthcare Provider";

                    controller.addBill(
                      MedicalActivity(
                        id: "ACT-${DateTime.now().millisecondsSinceEpoch}",
                        title: title,
                        providerName: provider,
                        amount: amt,
                        coveredAmount: amt * 0.9,
                        date: DateTime.now(),
                        status: ActivityStatus.approved,
                        category: category,
                      ),
                    );
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showCheckCoverageModal(BuildContext context, AppController controller) {
    Get.bottomSheet(
      ResponsiveCenter(
        maxWidth: 550,
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.search_rounded, color: AppColors.primaryTeal),
                  SizedBox(width: 8),
                  Text(
                    "On-Device Coverage Search",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter procedure or hospital (e.g. Angioplasty)",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.protectiveGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.protectiveGreen,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Angioplasty is 100% Cashless under your HDFC ERGO policy up to ₹10,00,000.",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.protectiveGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: "Close Search",
                onPressed: () => Get.back(),
                type: ButtonType.secondaryGold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
