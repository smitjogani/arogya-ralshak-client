import 'package:flutter_test/flutter_test.dart';
import 'package:aarogya_rakshak/services/ai_prompt_service.dart';

void main() {
  group('AiPromptService 5-Step Pipeline Tests', () {
    test('Prompt 1: Policy Extraction Prompt template check', () {
      final prompt = AiPromptService.buildPolicyExtractionUserPrompt("SAMPLE POLICY TEXT");
      expect(prompt, contains("sum_insured (number)"));
      expect(prompt, contains("room_rent_limit (number or \"No limit\")"));
      expect(prompt, contains("copay_percentage (number)"));
      expect(prompt, contains("waiting_periods (list of strings)"));
      expect(prompt, contains("major_exclusions (list of strings)"));
      expect(prompt, contains("sub_limits (object with key procedure/room type and value limit)"));
      expect(prompt, contains("policy_name (string)"));
      expect(prompt, contains("insurer_name (string)"));
      expect(prompt, contains("SAMPLE POLICY TEXT"));
    });

    test('Prompt 2: Hospital Bill Analysis Prompt template check', () {
      final prompt = AiPromptService.buildBillAnalysisUserPrompt("SAMPLE BILL TEXT");
      expect(prompt, contains("total_amount (number)"));
      expect(prompt, contains("room_type (string)"));
      expect(prompt, contains("room_rate_per_day (number)"));
      expect(prompt, contains("number_of_days (number if available)"));
      expect(prompt, contains("line_items (array of objects with: item_name, amount, category)"));
      expect(prompt, contains("package_name (string if it is a package)"));
      expect(prompt, contains("is_package_billing (true/false)"));
      expect(prompt, contains("non_payable_candidates (list of items that commonly are not covered)"));
      expect(prompt, contains("SAMPLE BILL TEXT"));
    });

    test('Prompt 3: Red Flag Detection Prompt template check', () {
      final prompt = AiPromptService.buildRedFlagDetectionUserPrompt('{"sum_insured": 500000}', '{"total_amount": 600000}');
      expect(prompt, contains("Policy Rules:"));
      expect(prompt, contains("Bill Data:"));
      expect(prompt, contains('"red_flags"'));
      expect(prompt, contains('"severity": "High/Medium/Low"'));
    });

    test('Prompt 4: Questions Generator Prompt template check', () {
      final prompt = AiPromptService.buildQuestionsGeneratorUserPrompt('{"red_flags": []}', 'Total: 50000');
      expect(prompt, contains("generate 5 to 8 clear questions"));
      expect(prompt, contains('"questions"'));
    });

    test('Prompt 5: Emergency Snapshot Summary Prompt template check', () {
      final prompt = AiPromptService.buildEmergencySummaryUserPrompt(
        best: "₹0",
        worst: "₹3,500",
        covered: "₹92,500",
        redFlagsCount: 2,
      );
      expect(prompt, contains("Estimated Out-of-Pocket Range: ₹0 – ₹3,500"));
      expect(prompt, contains("Covered by Insurance: ₹92,500"));
      expect(prompt, contains("Potential Issues: 2"));
      expect(prompt, contains("Write 3-4 short sentences only"));
    });

    test('End-to-End Pipeline Execution', () async {
      const policyText = '''
Policy Name: Optima Secure
Insurer Name: HDFC ERGO
Sum Insured: ₹10,00,000
Room Rent Limit: Single Private Room (No limit)
Copay: 0%
''';

      const billText = '''
Total Amount: ₹92,500
Room Type: Deluxe Single Private Suite
Room Rate: ₹8,500 per day
Number of Days: 4
Package Name: Cardiac Stenting Package
Is Package Billing: true
Line Items:
- Room Rent: ₹34,000
- Doctor Fee: ₹35,000
Non-payable items: Surgical Gloves, Mask Kit
''';

      final result = await AiPromptService.instance.runFullPipeline(
        policyText: policyText,
        billText: billText,
      );

      expect(result.policy.insurerName, contains("HDFC ERGO"));
      expect(result.policy.sumInsured, equals(1000000.0));
      expect(result.bill.totalAmount, equals(92500.0));
      expect(result.redFlags.redFlags.isNotEmpty, isTrue);
      expect(result.questions.questions.length, greaterThanOrEqualTo(5));
      expect(result.summary.summaryText.isNotEmpty, isTrue);
    });
  });
}
