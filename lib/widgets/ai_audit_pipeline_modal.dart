import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/ai_prompt_models.dart';
import '../services/ai_prompt_service.dart';
import '../theme/app_colors.dart';
import 'app_card.dart';
import 'custom_button.dart';
import 'responsive_layout.dart';
import 'status_badge.dart';

class AiAuditPipelineModal extends StatefulWidget {
  const AiAuditPipelineModal({super.key});

  static void show(BuildContext context) {
    Get.bottomSheet(
      ResponsiveCenter(
        maxWidth: 720,
        child: SafeArea(
          bottom: true,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.90,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 28,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const AiAuditPipelineModal(),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  State<AiAuditPipelineModal> createState() => _AiAuditPipelineModalState();
}

class _AiAuditPipelineModalState extends State<AiAuditPipelineModal>
    with SingleTickerProviderStateMixin {
  final TextEditingController _policyTextController = TextEditingController();
  final TextEditingController _billTextController = TextEditingController();

  bool _isProcessing = false;
  int _currentPipelineStep = 0; // 0 to 5
  FullAnalysisPipelineResult? _pipelineResult;

  late TabController _tabController;

  static const String samplePolicyOcr = '''
HDFC ERGO Health Insurance Policy Document
Policy No: HDFC-HLTH-994821
Insurer Name: HDFC ERGO Health Insurance Co. Ltd.
Plan Name: Optima Secure Complete
Sum Insured: ₹10,00,000 (Ten Lakhs)
Room Rent Limit: Single Private Deluxe Room (No Capping Limit)
Co-payment: 0% (No Mandatory Co-pay)

Waiting Periods:
1. Initial 30-day waiting period for all non-emergency illnesses.
2. 24-month waiting period for Cataract, Joint Replacement & Hernia.
3. 36-month waiting period for Pre-Existing Conditions (PED).

Major Exclusions:
- Cosmetic or plastic surgeries unless reconstructive due to accident.
- Experimental treatments & unproven therapies.
- Self-inflicted injuries or substance abuse rehabilitation.
- Non-prescription vitamins & dietary supplements.

Sub-limits:
- Cataract Surgery: Capped at ₹40,000 per eye.
- Robotic Surgery: Up to 50% of Sum Insured.
''';

  static const String sampleBillOcr = '''
APOLLO MULTISPECIALTY HOSPITAL ESTIMATE & BILL
Patient Name: Rajesh Kumar | Admission Date: 12-Sep-2026
Room Category: Deluxe Single Private Suite
Room Rate per Day: ₹8,500 | Number of Days: 4

Package Details:
Is Package Billing: Yes
Package Name: Cardiac Angiography & Stenting Care Package
Total Estimate Amount: ₹92,500

Itemized Line Items:
1. ICU & Deluxe Suite Rent (4 Days @ ₹8,500/day): ₹34,000 [Room Charges]
2. Senior Cardiologist Specialist Fees: ₹32,000 [Professional Fees]
3. Cath Lab & Operating Theatre Charges: ₹14,000 [Procedure]
4. Diagnostic CT Angiography & Blood Panel: ₹6,500 [Diagnostics]
5. Prescription Medicines & IV Fluids: ₹3,600 [Medicines]
6. Disposable Surgical Gloves, PPE & Hygiene Apron: ₹2,400 [Consumables]

Identified Non-Payable Candidates:
- Surgical Gloves & Mask Kit
- Patient Hygiene & Sanitary Apron
- Administrative Registration Fee
- Admission Kit & Digital Thermometer
''';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _policyTextController.text = samplePolicyOcr;
    _billTextController.text = sampleBillOcr;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _policyTextController.dispose();
    _billTextController.dispose();
    super.dispose();
  }

  Future<void> _runPipeline() async {
    final policyText = _policyTextController.text.trim();
    final billText = _billTextController.text.trim();

    if (policyText.isEmpty || billText.isEmpty) {
      Get.snackbar(
        "Missing Inputs",
        "Please provide both Policy text and Bill text to audit.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.emergencyRed,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isProcessing = true;
      _currentPipelineStep = 1;
      _pipelineResult = null;
    });

    try {
      // Step 1: Policy Extraction
      final policyRes = await AiPromptService.instance.extractPolicy(policyText);
      setState(() => _currentPipelineStep = 2);

      // Step 2: Bill Analysis
      final billRes = await AiPromptService.instance.analyzeBill(billText);
      setState(() => _currentPipelineStep = 3);

      // Step 3: Red Flag Detection
      final redFlagsRes = await AiPromptService.instance.detectRedFlags(
        policy: policyRes,
        bill: billRes,
      );
      setState(() => _currentPipelineStep = 4);

      // Step 4: Questions Generator
      final questionsRes = await AiPromptService.instance.generateQuestions(
        redFlags: redFlagsRes,
        bill: billRes,
      );
      setState(() => _currentPipelineStep = 5);

      // Step 5: Emergency Summary
      final bestOut = billRes.totalAmount > policyRes.sumInsured
          ? "₹${(billRes.totalAmount - policyRes.sumInsured).toStringAsFixed(0)}"
          : "₹0";
      final worstOut = "₹3,500";
      final coveredStr = "₹${(policyRes.sumInsured > billRes.totalAmount ? billRes.totalAmount : policyRes.sumInsured).toStringAsFixed(0)}";

      final summaryRes = await AiPromptService.instance.generateEmergencySummary(
        best: bestOut,
        worst: worstOut,
        covered: coveredStr,
        redFlagsCount: redFlagsRes.redFlags.where((rf) => rf.severity != "Low").length,
      );

      final fullRes = FullAnalysisPipelineResult(
        policy: policyRes,
        bill: billRes,
        redFlags: redFlagsRes,
        questions: questionsRes,
        summary: summaryRes,
        timestamp: DateTime.now(),
      );

      setState(() {
        _pipelineResult = fullRes;
        _isProcessing = false;
        _currentPipelineStep = 5;
      });

      _tabController.animateTo(2); // Jump to Red Flags tab
    } catch (e) {
      setState(() => _isProcessing = false);
      Get.snackbar(
        "Pipeline Error",
        "Error running AI pipeline: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.emergencyRed,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Modal Drag handle & Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
          child: Column(
            children: [
              Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTeal.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.psychology_rounded,
                          color: AppColors.primaryTeal,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "AI 5-Step Policy & Bill Auditor",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                          const Text(
                            "Strict JSON Prompts • Policy, Bill, Red Flags & Desk Questions",
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.primaryTeal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // Execution Step Progress Bar
        if (_isProcessing || _pipelineResult != null) _buildPipelineProgressBar(isDark),

        // Tabs Header
        TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primaryTeal,
          unselectedLabelColor: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          indicatorColor: AppColors.primaryTeal,
          tabs: const [
            Tab(text: "1. Inputs"),
            Tab(text: "2. Policy Data"),
            Tab(text: "3. Bill Analysis"),
            Tab(text: "4. Red Flags"),
            Tab(text: "5. Desk Questions"),
          ],
        ),

        // Tab Body Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildInputsTab(isDark),
              _buildPolicyTab(isDark),
              _buildBillTab(isDark),
              _buildRedFlagsTab(isDark),
              _buildQuestionsTab(isDark),
            ],
          ),
        ),

        // Bottom CTA Action Bar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: "Load Pre-filled Sample",
                  icon: Icons.text_snippet_rounded,
                  type: ButtonType.secondary,
                  onPressed: () {
                    setState(() {
                      _policyTextController.text = samplePolicyOcr;
                      _billTextController.text = sampleBillOcr;
                    });
                    Get.snackbar(
                      "Sample Loaded",
                      "Pre-filled sample policy and hospital bill for testing.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.primaryTeal,
                      colorText: Colors.white,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: CustomButton(
                  text: _isProcessing ? "Running 5 AI Prompts..." : "Execute 5-Step AI Audit",
                  icon: Icons.auto_awesome_rounded,
                  type: ButtonType.primary,
                  isLoading: _isProcessing,
                  onPressed: _isProcessing ? () {} : () => _runPipeline(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPipelineProgressBar(bool isDark) {
    final double progress = _currentPipelineStep / 5.0;
    return Container(
      color: AppColors.primaryTeal.withValues(alpha: 0.1),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isProcessing
                    ? "Step $_currentPipelineStep of 5: ${_getStepName(_currentPipelineStep)}"
                    : "Pipeline Complete (5/5 Steps)",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTeal,
                ),
              ),
              Text(
                "${(progress * 100).toInt()}%",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTeal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryTeal),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  String _getStepName(int step) {
    switch (step) {
      case 1:
        return "Extracting Policy Data (Prompt #1)";
      case 2:
        return "Analyzing Hospital Bill (Prompt #2)";
      case 3:
        return "Detecting Red Flags (Prompt #3)";
      case 4:
        return "Generating Desk Questions (Prompt #4)";
      case 5:
        return "Creating Emergency Snapshot (Prompt #5)";
      default:
        return "Complete";
    }
  }

  // TAB 1: Inputs Tab
  Widget _buildInputsTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "1. Policy Text / OCR Input:",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _policyTextController,
            maxLines: 6,
            style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
            decoration: InputDecoration(
              hintText: "Paste health insurance policy terms or OCR text...",
              filled: true,
              fillColor: isDark ? AppColors.surfaceDark : Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "2. Hospital Bill / Estimate OCR Input:",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _billTextController,
            maxLines: 7,
            style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
            decoration: InputDecoration(
              hintText: "Paste hospital estimate or itemized bill OCR text...",
              filled: true,
              fillColor: isDark ? AppColors.surfaceDark : Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: Policy Extracted Data
  Widget _buildPolicyTab(bool isDark) {
    if (_pipelineResult == null) {
      return _buildEmptyTabPlaceholder("Run 5-Step AI Audit to view extracted Policy terms.");
    }

    final p = _pipelineResult!.policy;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      p.policyName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.primaryTeal,
                      ),
                    ),
                    StatusBadge(
                      label: p.insurerName,
                      type: BadgeType.covered,
                    ),

                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                _buildDataRow("Sum Insured:", "₹${p.sumInsured.toStringAsFixed(0)}", isDark),
                _buildDataRow("Room Rent Limit:", p.roomRentLimit, isDark),
                _buildDataRow("Copay Percentage:", "${p.copayPercentage.toStringAsFixed(0)}%", isDark),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text("Waiting Periods:", style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
          const SizedBox(height: 6),
          ...p.waitingPeriods.map((wp) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 14, color: AppColors.accentGold),
                    const SizedBox(width: 8),
                    Expanded(child: Text(wp, style: const TextStyle(fontSize: 12.5))),
                  ],
                ),
              )),
          const SizedBox(height: 14),
          Text("Major Exclusions:", style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
          const SizedBox(height: 6),
          ...p.majorExclusions.map((ex) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    const Icon(Icons.cancel_outlined, size: 14, color: AppColors.emergencyRed),
                    const SizedBox(width: 8),
                    Expanded(child: Text(ex, style: const TextStyle(fontSize: 12.5))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // TAB 3: Bill Analysis Data
  Widget _buildBillTab(bool isDark) {
    if (_pipelineResult == null) {
      return _buildEmptyTabPlaceholder("Run 5-Step AI Audit to view analyzed Hospital Bill data.");
    }

    final b = _pipelineResult!.bill;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDataRow("Total Estimate:", "₹${b.totalAmount.toStringAsFixed(0)}", isDark, isBold: true),
                _buildDataRow("Room Category:", b.roomType, isDark),
                _buildDataRow("Daily Room Rate:", "₹${b.roomRatePerDay.toStringAsFixed(0)} / day", isDark),
                _buildDataRow("Package Billing:", b.isPackageBilling ? "Yes (${b.packageName})" : "No", isDark),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text("Itemized Line Items:", style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
          const SizedBox(height: 8),
          ...b.lineItems.map((item) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.itemName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          Text(item.category, style: TextStyle(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                        ],
                      ),
                    ),
                    Text("₹${item.amount.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryTeal)),
                  ],
                ),
              )),
          const SizedBox(height: 14),
          Text("Potential Non-Payables:", style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
          const SizedBox(height: 6),
          ...b.nonPayableCandidates.map((np) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.warningOrange),
                    const SizedBox(width: 8),
                    Text(np, style: const TextStyle(fontSize: 12.5)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // TAB 4: Red Flags Tab
  Widget _buildRedFlagsTab(bool isDark) {
    if (_pipelineResult == null) {
      return _buildEmptyTabPlaceholder("Run 5-Step AI Audit to detect potential Policy vs Bill Red Flags.");
    }

    final flags = _pipelineResult!.redFlags.redFlags;
    final summaryText = _pipelineResult!.summary.summaryText;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emergency Snapshot Card (Prompt #5 output)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryTeal.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryTeal.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.shield_outlined, color: AppColors.primaryTeal, size: 18),
                    SizedBox(width: 8),
                    Text(
                      "EMERGENCY FINANCIAL SNAPSHOT (PROMPT 5)",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTeal,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  summaryText,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Text(
            "Detected Policy & Bill Red Flags (${flags.length}):",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 10),

          ...flags.map((flag) {
            Color sevColor;
            IconData sevIcon;
            if (flag.severity == "High") {
              sevColor = AppColors.emergencyRed;
              sevIcon = Icons.warning_amber_rounded;
            } else if (flag.severity == "Medium") {
              sevColor = AppColors.warningOrange;
              sevIcon = Icons.report_problem_outlined;
            } else {
              sevColor = AppColors.protectiveGreen;
              sevIcon = Icons.check_circle_outline;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: sevColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: sevColor.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(sevIcon, color: sevColor, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                flag.issue,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: sevColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: sevColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${flag.severity} Risk",
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    flag.reason,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // TAB 5: Questions to Ask Generator (Prompt #4 output)
  Widget _buildQuestionsTab(bool isDark) {
    if (_pipelineResult == null) {
      return _buildEmptyTabPlaceholder("Run 5-Step AI Audit to generate polite, firm Desk Questions.");
    }

    final questions = _pipelineResult!.questions.questions;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.accentGold),
            ),
            child: const Row(
              children: [
                Icon(Icons.help_outline_rounded, color: AppColors.accentGold, size: 22),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Show or ask these questions directly at the hospital billing desk or insurance counter.",
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Questions for Billing & Insurance Desk (${questions.length}):",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 10),
          ...questions.map((q) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_right_alt_rounded, color: AppColors.primaryTeal, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        q,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.primaryTeal),
                      tooltip: "Copy Question",
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: q));
                        Get.snackbar(
                          "Question Copied",
                          "Copied to clipboard for hospital desk discussion.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.primaryTeal,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                      },
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildEmptyTabPlaceholder(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome_outlined, size: 48, color: AppColors.primaryTeal),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.textMutedLight),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String title, String val, bool isDark, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 12.5, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
          Text(
            val,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold ? AppColors.primaryTeal : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            ),
          ),
        ],
      ),
    );
  }
}
