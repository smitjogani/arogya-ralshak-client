import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/app_controller.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_card.dart';
import '../auth/auth_screen.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/responsive_layout.dart';
import '../../widgets/section_header.dart';
import '../../widgets/status_badge.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWide = ResponsiveLayout.isWide(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile & AI Settings"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.qr_code_2_rounded,
              color: AppColors.primaryTeal,
            ),
            onPressed: () {
              Get.snackbar(
                "Health Card QR",
                "Showing offline encrypted health pass",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.primaryTeal,
                colorText: Colors.white,
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ResponsiveCenter(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Banner Card & On-Device AI Engine Settings Card
              if (isWide) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildUserProfileHeader(isDark),
                          const SizedBox(height: 20),
                          SectionHeader(
                            title: "Privacy & Preferences",
                            subtitle: "Biometrics, theme & local data",
                            icon: Icons.tune_rounded,
                          ),
                          const SizedBox(height: 10),
                          _buildPreferencesCard(context, controller, isDark),
                        ],
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeader(
                            title: "On-Device AI Engine",
                            subtitle: "Model health, memory & zero-cloud diagnostics",
                            icon: Icons.memory_rounded,
                          ),
                          const SizedBox(height: 10),
                          _buildAiEngineSettingsCard(isDark, controller),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
              ] else ...[
                _buildUserProfileHeader(isDark),
                const SizedBox(height: 18),

                SectionHeader(
                  title: "On-Device AI Engine",
                  subtitle: "Model health, memory & zero-cloud diagnostics",
                  icon: Icons.memory_rounded,
                ),
                const SizedBox(height: 10),
                _buildAiEngineSettingsCard(isDark, controller),
                const SizedBox(height: 20),
              ],

              // Linked Family Members & Insurance Policies: Side-by-side on wide screens
              if (isWide) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeader(
                            title: "Covered Family Members",
                            subtitle: "4 members under active policy",
                            actionText: "+ Add",
                            onActionTap: () {
                              Get.snackbar(
                                "Add Member",
                                "Opening family member addition form",
                                backgroundColor: AppColors.primaryTeal,
                                colorText: Colors.white,
                              );
                            },
                            icon: Icons.family_restroom_rounded,
                          ),
                          const SizedBox(height: 10),
                          _buildFamilyMembersList(isDark, controller),
                        ],
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeader(
                            title: "Linked Insurance Policies",
                            subtitle: "Active cashless network integrations",
                            icon: Icons.shield_rounded,
                          ),
                          const SizedBox(height: 10),
                          _buildLinkedPoliciesCard(isDark),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ] else ...[
                SectionHeader(
                  title: "Covered Family Members",
                  subtitle: "4 members under active policy",
                  actionText: "+ Add",
                  onActionTap: () {
                    Get.snackbar(
                      "Add Member",
                      "Opening family member addition form",
                      backgroundColor: AppColors.primaryTeal,
                      colorText: Colors.white,
                    );
                  },
                  icon: Icons.family_restroom_rounded,
                ),
                const SizedBox(height: 10),
                _buildFamilyMembersList(isDark, controller),
                const SizedBox(height: 20),

                SectionHeader(
                  title: "Linked Insurance Policies",
                  subtitle: "Active cashless network integrations",
                  icon: Icons.shield_rounded,
                ),
                const SizedBox(height: 10),
                _buildLinkedPoliciesCard(isDark),
                const SizedBox(height: 20),

                SectionHeader(
                  title: "Privacy & Preferences",
                  subtitle: "Biometrics, theme & local data",
                  icon: Icons.tune_rounded,
                ),
                const SizedBox(height: 10),
                _buildPreferencesCard(context, controller, isDark),
                const SizedBox(height: 24),
              ],

              // Data Export & Danger Zone
              _buildAccountActionsRow(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileHeader(bool isDark) {
    return AppCard(
      hasGoldAccent: true,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryLightTeal, AppColors.primaryTeal],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accentGold, width: 2),
            ),
            child: const Center(
              child: Text(
                "RK",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rajesh Kumar",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Primary Policyholder • O+ Positive",
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 6),
                const StatusBadge(
                  label: "Shield Gold Member",
                  type: BadgeType.goldTag,
                  customIcon: Icons.verified_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiEngineSettingsCard(bool isDark, AppController controller) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.bolt_rounded,
                    color: AppColors.accentGold,
                    size: 20,
                  ),
                  SizedBox(width: 6),
                  Text(
                    "Local MedLLM Status",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              StatusBadge(
                label: controller.isAiModelReady.value
                    ? "Active & Warm"
                    : "Syncing",
                type: BadgeType.cashless,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildInfoRow(
            isDark,
            label: "Model Architecture",
            value: "Aarogya-MedLLM (INT4)",
          ),
          _buildInfoRow(
            isDark,
            label: "On-Device Storage",
            value: "1.2 GB (Local Cache)",
          ),
          _buildInfoRow(
            isDark,
            label: "Execution Latency",
            value: "42 tokens/sec (Hardware NPU)",
          ),
          _buildInfoRow(
            isDark,
            label: "Last Knowledge Sync",
            value: controller.lastSyncTime.value,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Get.snackbar(
                  "Check AI Updates",
                  "Latest emergency network rules are up to date",
                  backgroundColor: AppColors.primaryTeal,
                  colorText: Colors.white,
                );
              },
              icon: const Icon(
                Icons.sync_rounded,
                size: 16,
                color: AppColors.primaryTeal,
              ),
              label: const Text(
                "Check Offline Rule Updates",
                style: TextStyle(fontSize: 13, color: AppColors.primaryTeal),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryTeal),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    bool isDark, {
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              color: isDark
                  ? AppColors.textMutedDark
                  : AppColors.textMutedLight,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyMembersList(bool isDark, AppController controller) {
    return Obx(() {
      final members = controller.familyMembers;
      return Column(
        children: members.map((m) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: AppColors.primaryTeal,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          "${m.relation} • ${m.age}",
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.emergencyRed.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      m.bloodGroup,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.emergencyRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildLinkedPoliciesCard(bool isDark) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPolicyTile(
            isDark,
            title: "HDFC ERGO Health Optima Secure",
            policyNo: "HDFC-HLTH-994821",
            coverage: "₹10,00,000",
            status: "Primary Active",
          ),
          const Divider(height: 16),
          _buildPolicyTile(
            isDark,
            title: "Star Health Super Surplus Top-Up",
            policyNo: "STAR-TOP-441209",
            coverage: "₹25,00,000",
            status: "Top-Up Active",
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyTile(
    bool isDark, {
    required String title,
    required String policyNo,
    required String coverage,
    required String status,
  }) {
    return Row(
      children: [
        const Icon(
          Icons.shield_outlined,
          color: AppColors.accentGold,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                policyNo,
                style: TextStyle(
                  fontSize: 11.5,
                  color: isDark
                      ? AppColors.textMutedDark
                      : AppColors.textMutedLight,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              coverage,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryTeal,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              status,
              style: const TextStyle(
                fontSize: 10.5,
                color: AppColors.protectiveGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreferencesCard(
    BuildContext context,
    AppController controller,
    bool isDark,
  ) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            // Dark Mode Switch
            Obx(
              () => SwitchListTile(
                title: const Text(
                  "Dark Theme",
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text("High contrast night mode"),
                secondary: const Icon(
                  Icons.dark_mode_rounded,
                  color: AppColors.accentGold,
                ),
                value: controller.isDarkMode.value,
                onChanged: (val) => controller.toggleTheme(),
              ),
            ),
            const Divider(height: 1),
            SwitchListTile(
              title: const Text(
                "Biometric Lock",
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
              ),
              subtitle: const Text("Require Fingerprint / Face ID to open SOS"),
              secondary: const Icon(
                Icons.fingerprint_rounded,
                color: AppColors.primaryTeal,
              ),
              value: true,
              onChanged: (val) {},
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(
                Icons.lock_open_rounded,
                color: AppColors.primaryTeal,
              ),
              title: const Text(
                "Account Security & Sign Out",
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
              ),
              subtitle: const Text("Manage password, registration & active account"),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                Get.to(() => const AuthScreen());
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(
                Icons.cleaning_services_rounded,
                color: AppColors.warningOrange,
              ),
              title: const Text(
                "Clear Local On-Device Cache",
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
              ),
              subtitle: const Text("Frees up 120 MB temporary files"),
              onTap: () {
                Get.snackbar(
                  "Cache Cleared",
                  "Local temporary files cleared",
                  backgroundColor: AppColors.primaryTeal,
                  colorText: Colors.white,
                );
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildAccountActionsRow(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: "Export Medical Data (PDF)",
          icon: Icons.download_rounded,
          type: ButtonType.secondaryGold,
          onPressed: () {
            Get.snackbar(
              "Exporting Data",
              "Generating local encrypted backup file",
              backgroundColor: AppColors.primaryTeal,
              colorText: Colors.white,
            );
          },
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () {
            Get.dialog(
              AlertDialog(
                title: const Text("Delete Local Account & Cache?"),
                content: const Text(
                  "This will erase all local AI models, offline pre-authorizations, and logged bills permanently.",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      "Erase All Data",
                      style: TextStyle(
                        color: AppColors.emergencyRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(
            Icons.delete_forever_rounded,
            color: AppColors.emergencyRed,
            size: 18,
          ),
          label: const Text(
            "Wipe Local Data & Reset App",
            style: TextStyle(
              color: AppColors.emergencyRed,
              fontWeight: FontWeight.bold,
              fontSize: 13.5,
            ),
          ),
        ),
      ],
    );
  }
}
