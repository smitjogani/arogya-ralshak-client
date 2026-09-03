enum ActivityStatus { approved, pending, covered, actionRequired }

class MedicalActivity {
  final String id;
  final String title;
  final String providerName;
  final double amount;
  final double coveredAmount;
  final DateTime date;
  final ActivityStatus status;
  final String category;

  MedicalActivity({
    required this.id,
    required this.title,
    required this.providerName,
    required this.amount,
    required this.coveredAmount,
    required this.date,
    required this.status,
    required this.category,
  });

  double get outOfPocket => amount - coveredAmount;
}

class HospitalEstimate {
  final String id;
  final String name;
  final String distance;
  final bool isNetwork;
  final double estimatedCostMin;
  final double estimatedCostMax;
  final bool cashlessAvailable;
  final String bedAvailability;
  final double rating;

  HospitalEstimate({
    required this.id,
    required this.name,
    required this.distance,
    required this.isNetwork,
    required this.estimatedCostMin,
    required this.estimatedCostMax,
    required this.cashlessAvailable,
    required this.bedAvailability,
    required this.rating,
  });
}

class InsurancePolicy {
  final String policyNumber;
  final String providerName;
  final String planName;
  final double totalCoverage;
  final double usedAmount;
  final DateTime renewalDate;
  final int coveredMembersCount;

  InsurancePolicy({
    required this.policyNumber,
    required this.providerName,
    required this.planName,
    required this.totalCoverage,
    required this.usedAmount,
    required this.renewalDate,
    required this.coveredMembersCount,
  });

  double get remainingCoverage => totalCoverage - usedAmount;
  double get utilizationPercentage => (usedAmount / totalCoverage).clamp(0.0, 1.0);
}

class AIInsight {
  final String id;
  final String title;
  final String description;
  final double potentialSavings;
  final String tag;
  final String actionText;

  AIInsight({
    required this.id,
    required this.title,
    required this.description,
    required this.potentialSavings,
    required this.tag,
    required this.actionText,
  });
}

class FamilyMember {
  final String name;
  final String relation;
  final String age;
  final String bloodGroup;
  final bool isCovered;

  FamilyMember({
    required this.name,
    required this.relation,
    required this.age,
    required this.bloodGroup,
    required this.isCovered,
  });
}
