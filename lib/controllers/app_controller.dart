import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/models.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  final RxBool isDarkMode = false.obs;
  final RxInt currentTab = 0.obs;
  final RxBool isEmergencyActive = false.obs;
  final RxString selectedCategoryFilter = 'All'.obs;

  // On-Device AI Engine Status
  final RxString aiModelVersion = 'Aarogya-MedLLM 3.2B (Quantized INT4)'.obs;
  final RxBool isAiModelReady = true.obs;
  final RxString lastSyncTime = 'Today, 10:15 AM'.obs;

  // Insurance Policy Data
  late final Rx<InsurancePolicy> activePolicy;

  // Lists
  final RxList<MedicalActivity> activities = <MedicalActivity>[].obs;
  final RxList<HospitalEstimate> hospitals = <HospitalEstimate>[].obs;
  final RxList<AIInsight> aiInsights = <AIInsight>[].obs;
  final RxList<FamilyMember> familyMembers = <FamilyMember>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  void _loadInitialData() {
    activePolicy = InsurancePolicy(
      policyNumber: "HDFC-HLTH-994821",
      providerName: "HDFC ERGO Health",
      planName: "Optima Secure Complete",
      totalCoverage: 1000000.0,
      usedAmount: 120000.0,
      renewalDate: DateTime.now().add(const Duration(days: 145)),
      coveredMembersCount: 4,
    ).obs;

    activities.assignAll([
      MedicalActivity(
        id: "ACT-101",
        title: "Cardiac Pre-Authorization",
        providerName: "Apollo Multispecialty",
        amount: 45000.0,
        coveredAmount: 45000.0,
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: ActivityStatus.covered,
        category: "Hospitalization",
      ),
      MedicalActivity(
        id: "ACT-102",
        title: "MRI Brain & Cervical Scan",
        providerName: "Max Diagnostic Center",
        amount: 8500.0,
        coveredAmount: 8500.0,
        date: DateTime.now().subtract(const Duration(days: 5)),
        status: ActivityStatus.approved,
        category: "Diagnostics",
      ),
      MedicalActivity(
        id: "ACT-103",
        title: "Monthly Cardiac Meds",
        providerName: "Apollo Pharmacy Local",
        amount: 3200.0,
        coveredAmount: 2400.0,
        date: DateTime.now().subtract(const Duration(days: 12)),
        status: ActivityStatus.pending,
        category: "Medicines",
      ),
      MedicalActivity(
        id: "ACT-104",
        title: "Specialist Consultation",
        providerName: "Dr. R. Sharma Clinic",
        amount: 1500.0,
        coveredAmount: 1500.0,
        date: DateTime.now().subtract(const Duration(days: 18)),
        status: ActivityStatus.covered,
        category: "Consultation",
      ),
    ]);

    hospitals.assignAll([
      HospitalEstimate(
        id: "HOSP-1",
        name: "Fortis Escorts Heart Institute",
        distance: "1.2 km",
        isNetwork: true,
        estimatedCostMin: 75000.0,
        estimatedCostMax: 95000.0,
        cashlessAvailable: true,
        bedAvailability: "4 ICU Beds Available",
        rating: 4.8,
      ),
      HospitalEstimate(
        id: "HOSP-2",
        name: "Max Super Specialty Hospital",
        distance: "3.5 km",
        isNetwork: true,
        estimatedCostMin: 85000.0,
        estimatedCostMax: 110000.0,
        cashlessAvailable: true,
        bedAvailability: "2 ICU Beds Available",
        rating: 4.7,
      ),
      HospitalEstimate(
        id: "HOSP-3",
        name: "Medanta Medicity Specialty",
        distance: "5.8 km",
        isNetwork: false,
        estimatedCostMin: 110000.0,
        estimatedCostMax: 140000.0,
        cashlessAvailable: false,
        bedAvailability: "6 Beds Available",
        rating: 4.9,
      ),
    ]);

    aiInsights.assignAll([
      AIInsight(
        id: "INS-1",
        title: "Save up to ₹18,500 on Planned Surgeries",
        description: "Selecting Fortis (Tier-1 Network) rather than Medanta eliminates out-of-pocket room copayments.",
        potentialSavings: 18500.0,
        tag: "Hospital Network",
        actionText: "Compare Network Hospitals",
      ),
      AIInsight(
        id: "INS-2",
        title: "Claim Action Required for Diagnostics",
        description: "Your ₹3,200 MRI claim needs a doctor's referral stamp attached to get 100% reimbursement.",
        potentialSavings: 3200.0,
        tag: "Reimbursement",
        actionText: "Upload Referral Note",
      ),
      AIInsight(
        id: "INS-3",
        title: "No-Cost Restore Benefit Active",
        description: "Your HDFC ERGO policy restores ₹10,00,000 automatically if 100% utilized for cardiac illness.",
        potentialSavings: 1000000.0,
        tag: "Policy Benefit",
        actionText: "View Policy Terms",
      ),
    ]);

    familyMembers.assignAll([
      FamilyMember(name: "Rajesh Kumar", relation: "Self (Primary)", age: "42 Yrs", bloodGroup: "O+", isCovered: true),
      FamilyMember(name: "Sunita Kumar", relation: "Spouse", age: "39 Yrs", bloodGroup: "B+", isCovered: true),
      FamilyMember(name: "Aarav Kumar", relation: "Son", age: "12 Yrs", bloodGroup: "O+", isCovered: true),
      FamilyMember(name: "Savitri Devi", relation: "Mother", age: "68 Yrs", bloodGroup: "AB+", isCovered: true),
    ]);
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void changeTab(int index) {
    currentTab.value = index;
  }

  void triggerEmergencyMode() {
    isEmergencyActive.value = true;
    currentTab.value = 1; // Emergency Tab
  }

  void exitEmergencyMode() {
    isEmergencyActive.value = false;
  }

  void filterCategory(String category) {
    selectedCategoryFilter.value = category;
  }

  double get totalMedicalSpend => activities.fold(0.0, (sum, item) => sum + item.amount);
  double get totalCovered => activities.fold(0.0, (sum, item) => sum + item.coveredAmount);
  double get totalOutOfPocket => activities.fold(0.0, (sum, item) => sum + item.outOfPocket);

  void addBill(MedicalActivity newActivity) {
    activities.insert(0, newActivity);
    Get.snackbar(
      "Bill Added",
      "₹${newActivity.amount.toStringAsFixed(0)} logged to ${newActivity.category}",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0D7377),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  void scanPolicyDocument({
    required String policyNumber,
    required String providerName,
    required String planName,
    required double coverageAmount,
  }) {
    activePolicy.value = InsurancePolicy(
      policyNumber: policyNumber,
      providerName: providerName,
      planName: planName,
      totalCoverage: coverageAmount,
      usedAmount: activePolicy.value.usedAmount,
      renewalDate: DateTime.now().add(const Duration(days: 365)),
      coveredMembersCount: 4,
    );
    Get.snackbar(
      "Policy Scanned & Saved",
      "On-device OCR extracted $providerName ($planName) - ₹${coverageAmount.toStringAsFixed(0)} Cover",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0D7377),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
    );
  }
}

