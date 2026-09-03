import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/app_controller.dart';
import '../../theme/app_colors.dart';
import '../../widgets/ai_insight_card.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_chart.dart';
import '../../widgets/section_header.dart';
import '../../widgets/status_badge.dart';

class FinancesClarityScreen extends StatelessWidget {
  const FinancesClarityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Map<String, double> categoryData = {
      'Hospitalization': 45000.0,
      'Diagnostics': 8500.0,
      'Medicines': 3200.0,
      'Consultation': 1500.0,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Medical Finances & Clarity"),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.accentGold),
            onPressed: () {
              Get.snackbar(
                "Export Statement",
                "Generating Annual Medical Spend PDF statement",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.primaryTeal,
                colorText: Colors.white,
              );
            },
            tooltip: "Export Statement",
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Spend Header Card
            _buildSpendSummaryCard(isDark, controller),
            const SizedBox(height: 18),

            // Insurance Coverage Utilization Bar
            _buildInsuranceUtilizationCard(isDark, controller),
            const SizedBox(height: 20),

            // Spend Breakdown by Category Chart
            SectionHeader(
              title: "Category Spend Breakdown",
              subtitle: "Distribution across medical services",
              icon: Icons.pie_chart_rounded,
            ),
            const SizedBox(height: 10),
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CategorySpendChart(categoryData: categoryData),
                  const SizedBox(height: 12),
                  Divider(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Top Expense Category:", style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                      Text("Hospitalization (65.9%)", style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // AI Financial Insights Section
            SectionHeader(
              title: "AI Financial Recommendations",
              subtitle: "Optimizations computed locally by Aarogya-AI",
              icon: Icons.psychology_rounded,
            ),
            const SizedBox(height: 10),
            Obx(() => Column(
                  children: controller.aiInsights
                      .map((insight) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: AIInsightCard(
                              insight: insight,
                              onAction: () {
                                Get.snackbar("AI Recommendation", "Navigating to policy optimization tool", backgroundColor: AppColors.primaryTeal, colorText: Colors.white);
                              },
                            ),
                          ))
                      .toList(),
                )),
            const SizedBox(height: 20),

            // Category Filter Chips & Bill Activity
            SectionHeader(
              title: "All Medical Bills & Claims",
              subtitle: "Track status & out-of-pocket expenses",
              icon: Icons.receipt_long_rounded,
            ),
            const SizedBox(height: 8),
            _buildCategoryFilterChips(controller, isDark),
            const SizedBox(height: 12),
            _buildFilteredBillsList(controller, isDark),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendSummaryCard(bool isDark, AppController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF16252E), const Color(0xFF101B22)]
              : [AppColors.primaryTeal, AppColors.primaryDarkTeal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryTeal.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TOTAL MEDICAL SPEND (2026)",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const StatusBadge(label: "AI Tracked", type: BadgeType.goldTag),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() => Text(
                "₹${controller.totalMedicalSpend.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              )),
          const SizedBox(height: 14),
          Divider(color: Colors.white.withValues(alpha: 0.15)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Color(0x2EFFFFFF), shape: BoxShape.circle),
                      child: const Icon(Icons.shield_outlined, color: Color(0xFF4EFEAA), size: 16),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Covered by Policy", style: TextStyle(fontSize: 11, color: Colors.white70)),
                        Obx(() => Text(
                              "₹${controller.totalCovered.toStringAsFixed(0)}",
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 30, color: Colors.white24),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Color(0x2EFFFFFF), shape: BoxShape.circle),
                        child: const Icon(Icons.savings_outlined, color: AppColors.accentGold, size: 16),
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Saved via AI", style: TextStyle(fontSize: 11, color: Colors.white70)),
                          Text(
                            "₹24,200",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.accentGold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsuranceUtilizationCard(bool isDark, AppController controller) {
    return Obx(() {
      final policy = controller.activePolicy.value;
      final pct = policy.utilizationPercentage;

      return AppCard(
        hasGoldAccent: true,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      policy.providerName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      policy.planName,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "${(pct * 100).toStringAsFixed(0)}% Used",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 12,
                backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryTeal),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Claimed: ₹${policy.usedAmount.toStringAsFixed(0)}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text("Policy Limit: ₹${policy.totalCoverage.toStringAsFixed(0)}", style: TextStyle(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Remaining: ₹${policy.remainingCoverage.toStringAsFixed(0)}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.protectiveGreen)),
                    const SizedBox(height: 2),
                    const Text("No-Cost Restoration Ready", style: TextStyle(fontSize: 11, color: AppColors.protectiveGreen)),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCategoryFilterChips(AppController controller, bool isDark) {
    final categories = ['All', 'Hospitalization', 'Diagnostics', 'Medicines', 'Consultation'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(() {
        final currentFilter = controller.selectedCategoryFilter.value;
        return Row(
          children: categories.map((cat) {
            final isSelected = currentFilter == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                selectedColor: AppColors.primaryTeal,
                backgroundColor: isDark ? AppColors.cardDark : Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
                onSelected: (selected) {
                  if (selected) {
                    controller.filterCategory(cat);
                  }
                },
              ),
            );
          }).toList(),
        );
      }),
    );
  }

  Widget _buildFilteredBillsList(AppController controller, bool isDark) {
    return Obx(() {
      final filter = controller.selectedCategoryFilter.value;
      final filteredList = filter == 'All'
          ? controller.activities
          : controller.activities.where((a) => a.category == filter).toList();

      if (filteredList.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(24),
          alignment: Alignment.center,
          child: Text(
            "No expenses under $filter",
            style: TextStyle(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
          ),
        );
      }

      return Column(
        children: filteredList.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: AppCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.accentGold.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.receipt_long_rounded, color: AppColors.accentGold, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${item.providerName} • ${item.category}",
                          style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹${item.amount.toStringAsFixed(0)}",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Out-of-Pocket: ₹${item.outOfPocket.toStringAsFixed(0)}",
                        style: const TextStyle(fontSize: 11, color: AppColors.protectiveGreen, fontWeight: FontWeight.w600),
                      ),
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
}
