import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import '../theme/app_colors.dart';
import 'responsive_layout.dart';

class ChatMessageItem {
  final String id;
  final String text;
  final bool isUser;
  final DateTime time;
  final List<String>? actionChips;

  ChatMessageItem({
    required this.id,
    required this.text,
    required this.isUser,
    required this.time,
    this.actionChips,
  });
}

class AiChatModal extends StatefulWidget {
  const AiChatModal({super.key});

  static void show(BuildContext context) {
    Get.bottomSheet(
      ResponsiveCenter(
        maxWidth: 600,
        child: SafeArea(
          bottom: true,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const AiChatModal(),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  State<AiChatModal> createState() => _AiChatModalState();
}

class _AiChatModalState extends State<AiChatModal> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AppController _appController = Get.find<AppController>();

  bool _isAiThinking = false;

  final List<ChatMessageItem> _messages = [
    ChatMessageItem(
      id: '1',
      text:
          "Namaste Rajesh! 🙏 I am your **Aarogya-Rakshak On-Device AI Assistant**.\n\nI can analyze your active **HDFC ERGO Optima Secure (₹10,00,000)** policy, estimate cashless approvals, check room rent caps, & find zero out-of-pocket hospitals.\n\nHow can I assist your medical planning today?",
      isUser: false,
      time: DateTime.now().subtract(const Duration(minutes: 5)),
      actionChips: [
        "ICU & Room Rent limits?",
        "How to get 100% Cashless approval?",
        "Which nearby hospital saves max out-of-pocket?",
      ],
    ),
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessageItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isUser: true,
      time: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _isAiThinking = true;
    });

    _inputController.clear();
    _scrollToBottom();

    // Simulate On-Device AI Reasoning Engine (Aarogya-MedLLM 3.2B)
    Future.delayed(const Duration(milliseconds: 1300), () {
      if (!mounted) return;

      final aiResponse = _generateAiResponse(text, _appController);

      setState(() {
        _isAiThinking = false;
        _messages.add(aiResponse);
      });

      _scrollToBottom();
    });
  }

  ChatMessageItem _generateAiResponse(String userQuery, AppController controller) {
    final query = userQuery.toLowerCase();
    final policy = controller.activePolicy.value;

    if (query.contains("room") || query.contains("icu") || query.contains("rent")) {
      return ChatMessageItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text:
            "🟢 **Room Rent & ICU Coverage Status**:\n\nUnder your active **${policy.providerName} (${policy.planName})** policy:\n\n"
            "• **ICU Charges**: 100% Covered with NO sub-limit caps.\n"
            "• **Single Private Deluxe Room**: Fully covered without proportionate deduction.\n"
            "• **Total Available Cover**: ₹${policy.remainingCoverage.toStringAsFixed(0)} (out of ₹${policy.totalCoverage.toStringAsFixed(0)}).\n\n"
            "💡 *Tip: Ensure the hospital billing category remains within 'Single Standard Deluxe' to prevent room rent co-payments.*",
        isUser: false,
        time: DateTime.now(),
        actionChips: ["Compare Network Hospitals", "View Policy Exclusions"],
      );
    } else if (query.contains("cashless") || query.contains("approval") || query.contains("pre-auth")) {
      return ChatMessageItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text:
            "⚡ **Instant Cashless Pre-Authorization Guide**:\n\n"
            "1. **Present TPA Desk Card**: Show Policy No. `${policy.policyNumber}` at hospital insurance counter.\n"
            "2. **Pre-Auth Turnaround**: Average processing time is 45 mins for HDFC ERGO.\n"
            "3. **Initial Deposit Exemption**: Network hospitals cannot demand room deposit for cashless admissions.\n\n"
            "Would you like me to generate a 1-tap Pre-Auth Checklist for your doctor?",
        isUser: false,
        time: DateTime.now(),
        actionChips: ["Find Cashless Hospitals", "Generate Pre-Auth Form"],
      );
    } else if (query.contains("hospital") || query.contains("save") || query.contains("nearby")) {
      return ChatMessageItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text:
            "🏥 **Top Recommended Cashless Hospitals Nearby**:\n\n"
            "1. **Fortis Escorts Heart Institute** (1.2 km)\n"
            "   • Tier-1 Cashless Partner | ⭐ 4.8\n"
            "   • Estimated Out-of-Pocket: **₹0** (100% Covered)\n\n"
            "2. **Max Super Specialty Hospital** (3.5 km)\n"
            "   • Tier-1 Cashless Partner | ⭐ 4.7\n"
            "   • Estimated Out-of-Pocket: **₹0** (100% Covered)\n\n"
            "3. **Medanta Medicity** (5.8 km)\n"
            "   • Non-Network Reimbursement | Estimated Out-of-Pocket: ~₹18,500\n\n"
            "💡 *Recommendation: Fortis saves you ₹18,500 in non-network co-pays!*",
        isUser: false,
        time: DateTime.now(),
        actionChips: ["Activate Emergency Mode", "Calculate Surgery Cost"],
      );
    } else {
      return ChatMessageItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text:
            "🤖 **On-Device Medical AI Analysis**:\n\n"
            "Based on your **${policy.providerName}** policy data stored safely on your phone:\n\n"
            "• **Remaining Coverage**: ₹${policy.remainingCoverage.toStringAsFixed(0)}\n"
            "• **Auto-Restore Benefit**: Active (Restores ₹10,00,000 for unexpected illnesses)\n"
            "• **Deductible Status**: ₹0 out-of-pocket required for network hospital emergency admissions.\n\n"
            "Ask me specific questions about surgeries, diagnostics claims, or pre-existing disease waiting periods!",
        isUser: false,
        time: DateTime.now(),
        actionChips: ["ICU & Room Rent limits?", "Check Surgery Coverage"],
      );
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Header Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              bottom: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.accentGold, AppColors.primaryTeal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryTeal.withValues(alpha: 0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Aarogya Medical AI",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.protectiveGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "ON-DEVICE",
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.protectiveGreen,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Aarogya-MedLLM 3.2B • 100% Private & Instant",
                      style: TextStyle(fontSize: 11.5, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ),

        // Chat Message List
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: _messages.length + (_isAiThinking ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length && _isAiThinking) {
                return _buildAiThinkingBubble(isDark);
              }
              final msg = _messages[index];
              return _buildMessageBubble(context, msg, isDark);
            },
          ),
        ),

        // Input Field Container
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _inputController,
                  onSubmitted: _sendMessage,
                  decoration: InputDecoration(
                    hintText: "Ask about policy cover, ICU limits, bills...",
                    hintStyle: TextStyle(
                      fontSize: 13.5,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    filled: true,
                    fillColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryTeal, AppColors.primaryDarkTeal],
                  ),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  onPressed: () => _sendMessage(_inputController.text),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessageItem msg, bool isDark) {
    return Column(
      crossAxisAlignment: msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
          decoration: BoxDecoration(
            color: msg.isUser
                ? AppColors.primaryTeal
                : (isDark ? AppColors.surfaceDark : const Color(0xFFF0F4F6)),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: Radius.circular(msg.isUser ? 20 : 4),
              bottomRight: Radius.circular(msg.isUser ? 4 : 20),
            ),
            border: msg.isUser
                ? null
                : Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                msg.text,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: msg.isUser
                      ? Colors.white
                      : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                ),
              ),
            ],
          ),
        ),
        if (!msg.isUser && msg.actionChips != null && msg.actionChips!.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: msg.actionChips!.map((chipText) {
                return InkWell(
                  onTap: () => _sendMessage(chipText),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accentGold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.accentGold.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.chat_bubble_outline_rounded, size: 13, color: AppColors.accentDarkGold),
                        const SizedBox(width: 6),
                        Text(
                          chipText,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accentDarkGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAiThinkingBubble(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : const Color(0xFFF0F4F6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primaryTeal,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "Aarogya-MedLLM reasoning on-device...",
            style: TextStyle(
              fontSize: 12.5,
              fontStyle: FontStyle.italic,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
        ],
      ),
    );
  }
}

/// Floating Hover AI Assistant Button
class AiHoverButton extends StatefulWidget {
  final VoidCallback onTap;

  const AiHoverButton({super.key, required this.onTap});

  @override
  State<AiHoverButton> createState() => _AiHoverButtonState();
}

class _AiHoverButtonState extends State<AiHoverButton> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final glowProgress = _pulseController.value;

        return GestureDetector(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryTeal.withValues(alpha: 0.35 + (glowProgress * 0.25)),
                  blurRadius: 16 + (glowProgress * 8),
                  spreadRadius: 2 + (glowProgress * 2),
                ),
                BoxShadow(
                  color: AppColors.accentGold.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.accentGold, AppColors.primaryTeal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.8),
                  width: 1.5,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
