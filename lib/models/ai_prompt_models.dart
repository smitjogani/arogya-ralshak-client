
/// Step 1: Data model for Policy Extraction Prompt result
class PolicyExtractionResult {
  final double sumInsured;
  final String roomRentLimit; // e.g. "No limit" or "5000 per day"
  final double copayPercentage;
  final List<String> waitingPeriods;
  final List<String> majorExclusions;
  final Map<String, dynamic> subLimits;
  final String policyName;
  final String insurerName;

  PolicyExtractionResult({
    required this.sumInsured,
    required this.roomRentLimit,
    required this.copayPercentage,
    required this.waitingPeriods,
    required this.majorExclusions,
    required this.subLimits,
    required this.policyName,
    required this.insurerName,
  });

  factory PolicyExtractionResult.fromJson(Map<String, dynamic> json) {
    return PolicyExtractionResult(
      sumInsured: (json['sum_insured'] as num?)?.toDouble() ?? 0.0,
      roomRentLimit: json['room_rent_limit']?.toString() ?? "No limit",
      copayPercentage: (json['copay_percentage'] as num?)?.toDouble() ?? 0.0,
      waitingPeriods: (json['waiting_periods'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      majorExclusions: (json['major_exclusions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      subLimits: json['sub_limits'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['sub_limits'])
          : {},
      policyName: json['policy_name']?.toString() ?? "Health Shield Policy",
      insurerName: json['insurer_name']?.toString() ?? "Insurance Co.",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "sum_insured": sumInsured,
      "room_rent_limit": roomRentLimit,
      "copay_percentage": copayPercentage,
      "waiting_periods": waitingPeriods,
      "major_exclusions": majorExclusions,
      "sub_limits": subLimits,
      "policy_name": policyName,
      "insurer_name": insurerName,
    };
  }
}

/// Single Line Item in Hospital Bill
class BillLineItem {
  final String itemName;
  final double amount;
  final String category;

  BillLineItem({
    required this.itemName,
    required this.amount,
    required this.category,
  });

  factory BillLineItem.fromJson(Map<String, dynamic> json) {
    return BillLineItem(
      itemName: json['item_name']?.toString() ?? "Medical Charge",
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      category: json['category']?.toString() ?? "General",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "item_name": itemName,
      "amount": amount,
      "category": category,
    };
  }
}

/// Step 2: Data model for Hospital Bill / Estimate Analysis Prompt result
class BillAnalysisResult {
  final double totalAmount;
  final String roomType;
  final double roomRatePerDay;
  final int numberOfDays;
  final List<BillLineItem> lineItems;
  final String packageName;
  final bool isPackageBilling;
  final List<String> nonPayableCandidates;

  BillAnalysisResult({
    required this.totalAmount,
    required this.roomType,
    required this.roomRatePerDay,
    required this.numberOfDays,
    required this.lineItems,
    required this.packageName,
    required this.isPackageBilling,
    required this.nonPayableCandidates,
  });

  factory BillAnalysisResult.fromJson(Map<String, dynamic> json) {
    return BillAnalysisResult(
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      roomType: json['room_type']?.toString() ?? "Standard Deluxe",
      roomRatePerDay: (json['room_rate_per_day'] as num?)?.toDouble() ?? 0.0,
      numberOfDays: (json['number_of_days'] as num?)?.toInt() ?? 1,
      lineItems: (json['line_items'] as List<dynamic>?)
              ?.map((e) => BillLineItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      packageName: json['package_name']?.toString() ?? "",
      isPackageBilling: json['is_package_billing'] == true,
      nonPayableCandidates: (json['non_payable_candidates'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "total_amount": totalAmount,
      "room_type": roomType,
      "room_rate_per_day": roomRatePerDay,
      "number_of_days": numberOfDays,
      "line_items": lineItems.map((e) => e.toJson()).toList(),
      "package_name": packageName,
      "is_package_billing": isPackageBilling,
      "non_payable_candidates": nonPayableCandidates,
    };
  }

  String get summaryString {
    return "Total: ₹${totalAmount.toStringAsFixed(0)}, Room: $roomType (₹${roomRatePerDay.toStringAsFixed(0)}/day x $numberOfDays days), Package: ${isPackageBilling ? packageName : 'No'}, Non-payable items: ${nonPayableCandidates.join(', ')}";
  }
}

/// Single Red Flag item detected
class RedFlagItem {
  final String issue;
  final String reason;
  final String severity; // High / Medium / Low

  RedFlagItem({
    required this.issue,
    required this.reason,
    required this.severity,
  });

  factory RedFlagItem.fromJson(Map<String, dynamic> json) {
    return RedFlagItem(
      issue: json['issue']?.toString() ?? "Potential Audit Issue",
      reason: json['reason']?.toString() ?? "Requires verification with hospital desk.",
      severity: json['severity']?.toString() ?? "Medium",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "issue": issue,
      "reason": reason,
      "severity": severity,
    };
  }
}

/// Step 3: Data model for Red Flag Detection Prompt result
class RedFlagDetectionResult {
  final List<RedFlagItem> redFlags;

  RedFlagDetectionResult({required this.redFlags});

  factory RedFlagDetectionResult.fromJson(Map<String, dynamic> json) {
    return RedFlagDetectionResult(
      redFlags: (json['red_flags'] as List<dynamic>?)
              ?.map((e) => RedFlagItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "red_flags": redFlags.map((e) => e.toJson()).toList(),
    };
  }
}

/// Step 4: Data model for Questions Generator Prompt result
class QuestionsGeneratorResult {
  final List<String> questions;

  QuestionsGeneratorResult({required this.questions});

  factory QuestionsGeneratorResult.fromJson(Map<String, dynamic> json) {
    return QuestionsGeneratorResult(
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "questions": questions,
    };
  }
}

/// Step 5: Data model for Emergency Snapshot Summary Prompt result
class EmergencySummaryResult {
  final String summaryText;

  EmergencySummaryResult({required this.summaryText});

  factory EmergencySummaryResult.fromJson(Map<String, dynamic> json) {
    return EmergencySummaryResult(
      summaryText: json['summary']?.toString() ?? json['text']?.toString() ?? "",
    );
  }
}

/// Combined Pipeline execution result container
class FullAnalysisPipelineResult {
  final PolicyExtractionResult policy;
  final BillAnalysisResult bill;
  final RedFlagDetectionResult redFlags;
  final QuestionsGeneratorResult questions;
  final EmergencySummaryResult summary;
  final DateTime timestamp;

  FullAnalysisPipelineResult({
    required this.policy,
    required this.bill,
    required this.redFlags,
    required this.questions,
    required this.summary,
    required this.timestamp,
  });
}
