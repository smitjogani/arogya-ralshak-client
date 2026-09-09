import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/app_controller.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/responsive_layout.dart';
import '../../widgets/status_badge.dart';

class EmergencyModeScreen extends StatefulWidget {
  const EmergencyModeScreen({super.key});

  @override
  State<EmergencyModeScreen> createState() => _EmergencyModeScreenState();
}

class _EmergencyModeScreenState extends State<EmergencyModeScreen> {
  String selectedEmergencyType = 'Cardiac / Chest Pain';

  final List<String> emergencyTypes = [
    'Cardiac / Chest Pain',
    'Accident / Trauma',
    'Severe Respiratory',
    'High Fever / Infection',
    'ICU Admission',
  ];

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWide = ResponsiveLayout.isWide(context);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF140C0D)
          : const Color(0xFFFFF7F7),
      appBar: AppBar(
        backgroundColor: isDark
            ? const Color(0xFF1F1214)
            : const Color(0xFFFFECEC),
        title: const Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.emergencyRed,
              size: 26,
            ),
            SizedBox(width: 8),
            Text(
              "EMERGENCY CLARITY",
              style: TextStyle(
                color: AppColors.emergencyRed,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.protectiveGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.protectiveGreen),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 14,
                  color: AppColors.protectiveGreen,
                ),
                SizedBox(width: 4),
                Text(
                  "Offline Ready",
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.protectiveGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ResponsiveCenter(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
          child: isWide
              ? _buildWideEmergencyLayout(context, controller, isDark)
              : _buildMobileEmergencyLayout(context, controller, isDark),
        ),
      ),
    );
  }

  Widget _buildMobileEmergencyLayout(
    BuildContext context,
    AppController controller,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCalmNoticeHeader(isDark),
        const SizedBox(height: 16),

        Text(
          "Select Emergency Scenario:",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),
        _buildEmergencyScenarioChips(isDark),
        const SizedBox(height: 18),

        _buildSosActivationCard(controller),
        const SizedBox(height: 20),

        _buildCostEstimateCard(isDark),
        const SizedBox(height: 16),

        _buildCoverageBreakdownCard(isDark, controller),
        const SizedBox(height: 16),

        _buildUrgentActionRow(context, controller, isDark),
        const SizedBox(height: 22),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Nearby Cashless Hospitals",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            const StatusBadge(label: "Cashless", type: BadgeType.cashless),
          ],
        ),
        const SizedBox(height: 10),
        _buildNearbyHospitalsList(isDark, controller),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildWideEmergencyLayout(
    BuildContext context,
    AppController controller,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCalmNoticeHeader(isDark),
        const SizedBox(height: 16),

        Text(
          "Select Emergency Scenario:",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),
        _buildEmergencyScenarioChips(isDark),
        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column: Emergency SOS CTA & Cost Breakdown
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  _buildSosActivationCard(controller),
                  const SizedBox(height: 18),
                  _buildCostEstimateCard(isDark),
                  const SizedBox(height: 16),
                  _buildCoverageBreakdownCard(isDark, controller),
                  const SizedBox(height: 16),
                  _buildUrgentActionRow(context, controller, isDark),
                ],
              ),
            ),

            const SizedBox(width: 20),

            // Right Column: Nearby Cashless Hospitals Network List
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Nearby Cashless Hospitals",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      const StatusBadge(
                        label: "Cashless Ready",
                        type: BadgeType.cashless,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildNearbyHospitalsList(isDark, controller),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildEmergencyScenarioChips(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: emergencyTypes.map((type) {
          final isSelected = selectedEmergencyType == type;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(type),
              selected: isSelected,
              selectedColor: AppColors.emergencyRed,
              backgroundColor: isDark ? AppColors.cardDark : Colors.white,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    selectedEmergencyType = type;
                  });
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSosActivationCard(AppController controller) {
    return Obx(() {
      final isActive = controller.isEmergencyActive.value;
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: isActive
                ? [AppColors.emergencyRed, const Color(0xFF9E0B16)]
                : [AppColors.accentGold, const Color(0xFFB5840A)],
          ),
          boxShadow: [
            BoxShadow(
              color: (isActive ? AppColors.emergencyRed : AppColors.accentGold)
                  .withValues(alpha: 0.35),
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (isActive) {
                controller.exitEmergencyMode();
              } else {
                controller.triggerEmergencyMode();
              }
            },
            borderRadius: BorderRadius.circular(22),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isActive ? Icons.shield_rounded : Icons.bolt_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isActive
                              ? "EMERGENCY MODE ACTIVE"
                              : "ACTIVATE EMERGENCY CLARITY",
                          style: const TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isActive
                              ? "Showing immediate cashless pre-auth & nearby network limits"
                              : "Tap for 1-click hospital pre-authorization & cost breakdown",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCalmNoticeHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryTeal.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.verified_rounded, color: AppColors.primaryTeal, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Stay Calm. Your Policy (HDFC ERGO #994821) covers cashless admission at Tier-1 hospitals.",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostEstimateCard(bool isDark) {
    return AppCard(
      hasGoldAccent: true,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.accentGold.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.attach_money_rounded,
                      color: AppColors.accentGold,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Estimated Cost Range",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,

                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
              // const StatusBadge(
              //   label: "AI Calculated",
              //   type: BadgeType.goldTag,
              // ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "₹85,000 – ₹1,20,000",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.primaryTeal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Includes ICU Room, Angiography & Specialist Fees",
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoverageBreakdownCard(bool isDark, AppController controller) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Insurance vs Out-of-Pocket Breakdown",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildBreakdownPill(
                  isDark,
                  label: "100% Cashless",
                  value: "₹85,000",
                  subtext: "Covered by HDFC ERGO",
                  color: AppColors.protectiveGreen,
                  icon: Icons.check_circle_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBreakdownPill(
                  isDark,
                  label: "Out-of-Pocket",
                  value: "₹0 – ₹3,500",
                  subtext: "Non-medical gloves & mask",
                  color: AppColors.warningOrange,
                  icon: Icons.info_outline_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownPill(
    bool isDark, {
    required String label,
    required String value,
    required String subtext,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtext,
            style: TextStyle(
              fontSize: 11,
              color: isDark
                  ? AppColors.textMutedDark
                  : AppColors.textMutedLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentActionRow(
    BuildContext context,
    AppController controller,
    bool isDark,
  ) {
    return Column(
      children: [
        CustomButton(
          text: "Share Emergency with Family",
          icon: Icons.share_rounded,
          type: ButtonType.primary,
          onPressed: () => _showShareFamilyModal(context, controller),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: "Call Ambulance",
                icon: Icons.phone_in_talk_rounded,
                type: ButtonType.emergency,
                onPressed: () => _showCallAmbulanceModal(context),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomButton(
                text: "Pre-Auth Sheet",
                icon: Icons.description_rounded,
                type: ButtonType.secondaryGold,
                fontSize: 12,
                onPressed: () => _showPreAuthSheetModal(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNearbyHospitalsList(bool isDark, AppController controller) {
    return Obx(() {
      final list = controller.hospitals;
      return Column(
        children: list.map((hosp) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: AppCard(
              hasGoldAccent: hosp.isNetwork,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          hosp.name,
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                      StatusBadge(
                        label: hosp.isNetwork
                            ? "Network Cashless"
                            : "Non-Network",
                        type: hosp.isNetwork
                            ? BadgeType.cashless
                            : BadgeType.pending,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.near_me_rounded,
                            size: 14,
                            color: AppColors.primaryTeal,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${hosp.distance} away",
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: AppColors.accentGold,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${hosp.rating}",
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.king_bed_rounded,
                            size: 14,
                            color: AppColors.protectiveGreen,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            hosp.bedAvailability,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.protectiveGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Est: ₹${hosp.estimatedCostMin.toStringAsFixed(0)} - ₹${hosp.estimatedCostMax.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.primaryTeal,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.snackbar(
                            "Directions & Desk Contact",
                            "Navigating to ${hosp.name} Cashless Desk",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColors.primaryTeal,
                            colorText: Colors.white,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          "Navigate & Call Desk",
                          style: TextStyle(fontSize: 12),
                        ),
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

  void _showShareFamilyModal(BuildContext context, AppController controller) {
    Get.bottomSheet(
      ResponsiveCenter(
        maxWidth: 550,
        child: SafeArea(
          bottom: true,
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
                  Icon(
                    Icons.family_restroom_rounded,
                    color: AppColors.primaryTeal,
                    size: 26,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Share Emergency Pack",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                "Generates an instant encrypted PDF/WhatsApp message containing Policy #, Blood Group, Cashless Card ID & Emergency Contact Info.",
                style: TextStyle(fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 16),
              ...controller.familyMembers.map(
                (member) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${member.name} (${member.relation})",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        member.bloodGroup,
                        style: const TextStyle(
                          color: AppColors.emergencyRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              CustomButton(
                text: "Send via WhatsApp / SMS",
                icon: Icons.send_rounded,
                onPressed: () {
                  Get.back();
                  Get.snackbar(
                    "Emergency Pack Shared",
                    "Family notified with policy details",
                    backgroundColor: AppColors.protectiveGreen,
                    colorText: Colors.white,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }

  void _showCallAmbulanceModal(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.phone_in_talk_rounded, color: AppColors.emergencyRed),
            SizedBox(width: 8),
            Text("Emergency Helpline"),
          ],
        ),
        content: const Text(
          "Dialing 108 Emergency Medical Services & Fortis Ambulance Dispatcher.",
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emergencyRed,
            ),
            onPressed: () {
              Get.back();
              Get.snackbar(
                "Calling 108",
                "Connecting to National Emergency Ambulance",
                backgroundColor: AppColors.emergencyRed,
                colorText: Colors.white,
              );
            },
            child: const Text("Call 108 Now"),
          ),
        ],
      ),
    );
  }

  void _showPreAuthSheetModal(BuildContext context) {
    Get.bottomSheet(
      ResponsiveCenter(
        maxWidth: 550,
        child: SafeArea(
          bottom: true,
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
                  Icon(Icons.description_rounded, color: AppColors.accentGold),
                  SizedBox(width: 10),
                  Text(
                    "Cashless Pre-Auth Sheet",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                "On-Device AI pre-filled document ready to show to hospital TPA desk.",
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "• Policy: HDFC ERGO #994821",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("• Insured: Rajesh Kumar (O+)"),
                    Text("• Pre-Auth Limit: ₹10,00,000 Cashless"),
                    Text("• TPA Toll-Free: 1800-2666"),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: "Download / Show TPA Desk",
                icon: Icons.qr_code_rounded,
                onPressed: () => Get.back(),
                type: ButtonType.secondaryGold,
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
