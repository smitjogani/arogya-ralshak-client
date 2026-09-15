import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/responsive_layout.dart';
import '../main_navigation_shell.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final AuthController authController;

  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWide = ResponsiveLayout.isWide(context);

    return Scaffold(
      body: SafeArea(
        child: ResponsiveCenter(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Center(
            child: SingleChildScrollView(
              child: isWide
                  ? _buildWideAuthLayout(context, isDark)
                  : _buildMobileAuthLayout(context, isDark),
            ),
          ),
        ),
      ),
    );
  }

  // Mobile Auth Layout
  Widget _buildMobileAuthLayout(BuildContext context, bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        _buildBrandingHeader(isDark),
        const SizedBox(height: 20),
        Obx(() => _buildModeSegmentedControl(isDark)),
        const SizedBox(height: 20),
        Obx(() => _buildActiveFormCard(context, isDark)),
        const SizedBox(height: 20),
      ],
    );
  }

  // Wide/Desktop Auth Layout
  Widget _buildWideAuthLayout(BuildContext context, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Column: Branding & Feature Highlights
        Expanded(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppLogo(size: 80, animate: true),
              const SizedBox(height: 18),
              Text(
                "Aarogya-Rakshak",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.primaryTeal,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.4)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shield_rounded, size: 14, color: AppColors.accentGold),
                    SizedBox(width: 6),
                    Text(
                      "ON-DEVICE SECURE VAULT",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF9E750B),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Sign in to access your zero-cloud encrypted policy coverage, instant bill audits, & 24/7 emergency financial clarity.",
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 24),
              _buildSecurityBullet(
                isDark,
                icon: Icons.lock_outline_rounded,
                title: "100% Local Encryption",
                subtitle: "Your credentials & medical records stay strictly on your phone.",
              ),
              const SizedBox(height: 12),
              _buildSecurityBullet(
                isDark,
                icon: Icons.bolt_rounded,
                title: "Instant Cashless Pre-Auth",
                subtitle: "Real-time room rent & out-of-pocket calculation.",
              ),
            ],
          ),
        ),

        const SizedBox(width: 40),

        // Right Column: Active Auth Form Card
        Expanded(
          flex: 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => _buildModeSegmentedControl(isDark)),
              const SizedBox(height: 20),
              Obx(() => _buildActiveFormCard(context, isDark)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBrandingHeader(bool isDark) {
    return Column(
      children: [
        const AppLogo(size: 64, animate: true),
        const SizedBox(height: 12),
        Text(
          "Aarogya-Rakshak",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: isDark ? AppColors.textPrimaryDark : AppColors.primaryTeal,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "On-Device AI • Policy & Emergency Financial Clarity",
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildModeSegmentedControl(bool isDark) {
    final mode = authController.currentMode.value;
    final isLogin = mode == AuthMode.login;
    final isReg = mode == AuthMode.register;

    // Show tab switcher only for Login and Register modes
    if (mode == AuthMode.forgotPassword ||
        mode == AuthMode.otpVerification ||
        mode == AuthMode.resetPassword) {
      return Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => authController.switchMode(AuthMode.login),
            tooltip: "Back to Login",
          ),
          const SizedBox(width: 8),
          Text(
            mode == AuthMode.forgotPassword
                ? "Forgot Password"
                : mode == AuthMode.otpVerification
                    ? "Verify Reset Code"
                    : "Reset Password",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => authController.switchMode(AuthMode.login),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: isLogin
                      ? (isDark ? AppColors.surfaceDark : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isLogin
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  "Sign In",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isLogin ? FontWeight.bold : FontWeight.w600,
                    color: isLogin
                        ? AppColors.primaryTeal
                        : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => authController.switchMode(AuthMode.register),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: isReg
                      ? (isDark ? AppColors.surfaceDark : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isReg
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  "Create Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isReg ? FontWeight.bold : FontWeight.w600,
                    color: isReg
                        ? AppColors.primaryTeal
                        : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFormCard(BuildContext context, bool isDark) {
    final mode = authController.currentMode.value;

    switch (mode) {
      case AuthMode.login:
        return _buildLoginForm(context, isDark);
      case AuthMode.register:
        return _buildRegisterForm(context, isDark);
      case AuthMode.forgotPassword:
        return _buildForgotPasswordStep1(isDark);
      case AuthMode.otpVerification:
        return _buildForgotPasswordStep2(isDark);
      case AuthMode.resetPassword:
        return _buildForgotPasswordStep3(isDark);
    }
  }

  // FORM 1: Login with Password
  Widget _buildLoginForm(BuildContext context, bool isDark) {
    return AppCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome Back",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Enter your password to unlock your health insurance vault.",
            style: TextStyle(
              fontSize: 12.5,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          const SizedBox(height: 20),

          // Identifier Field
          _buildTextFieldLabel("Email or Phone Number", isDark),
          const SizedBox(height: 6),
          TextField(
            controller: authController.loginEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration(
              hint: "e.g. rajesh.kumar@health.in",
              icon: Icons.person_outline_rounded,
              isDark: isDark,
            ),
          ),
          const SizedBox(height: 16),

          // Password Field with Toggle
          _buildTextFieldLabel("Password", isDark),
          const SizedBox(height: 6),
          Obx(
            () => TextField(
              controller: authController.loginPasswordController,
              obscureText: !authController.isPasswordVisible.value,
              decoration: _inputDecoration(
                hint: "Enter your password",
                icon: Icons.lock_outline_rounded,
                isDark: isDark,
                suffixIcon: IconButton(
                  icon: Icon(
                    authController.isPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.primaryTeal,
                    size: 20,
                  ),
                  onPressed: () => authController.togglePasswordVisibility(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Remember Me & Forgot Password Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Obx(
                    () => Checkbox(
                      value: authController.rememberMe.value,
                      activeColor: AppColors.primaryTeal,
                      onChanged: (_) => authController.toggleRememberMe(),
                    ),
                  ),
                  Text(
                    "Remember me",
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => authController.switchMode(AuthMode.forgotPassword),
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Submit Button
          Obx(
            () => CustomButton(
              text: "Sign In with Password",
              icon: Icons.login_rounded,
              type: ButtonType.primary,
              isLoading: authController.isLoading.value,
              onPressed: () async {
                await authController.loginWithPassword();
                if (authController.isLoggedIn.value) {
                  Get.offAll(() => const MainNavigationShell());
                }
              },
            ),
          ),

          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("OR", style: TextStyle(fontSize: 11, color: AppColors.textMutedLight)),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 14),

          // Biometric Quick Login Button
          CustomButton(
            text: "Biometric Fingerprint Sign In",
            icon: Icons.fingerprint_rounded,
            type: ButtonType.secondaryGold,
            onPressed: () async {
              await authController.loginWithBiometrics();
              if (authController.isLoggedIn.value) {
                Get.offAll(() => const MainNavigationShell());
              }
            },
          ),
        ],
      ),
    );
  }

  // FORM 2: Register Form
  Widget _buildRegisterForm(BuildContext context, bool isDark) {
    return AppCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Create Account",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Set up your zero-cloud health insurance clarity account.",
            style: TextStyle(
              fontSize: 12.5,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          const SizedBox(height: 18),

          // Full Name
          _buildTextFieldLabel("Full Name", isDark),
          const SizedBox(height: 5),
          TextField(
            controller: authController.regFullNameController,
            decoration: _inputDecoration(hint: "Rajesh Kumar", icon: Icons.badge_outlined, isDark: isDark),
          ),
          const SizedBox(height: 14),

          // Email Address
          _buildTextFieldLabel("Email Address", isDark),
          const SizedBox(height: 5),
          TextField(
            controller: authController.regEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration(hint: "rajesh@example.com", icon: Icons.email_outlined, isDark: isDark),
          ),
          const SizedBox(height: 14),

          // Phone Number
          _buildTextFieldLabel("Phone Number", isDark),
          const SizedBox(height: 5),
          TextField(
            controller: authController.regPhoneController,
            keyboardType: TextInputType.phone,
            decoration: _inputDecoration(hint: "+91 98765 43210", icon: Icons.phone_outlined, isDark: isDark),
          ),
          const SizedBox(height: 14),

          // Policy Number (Optional)
          _buildTextFieldLabel("Health Policy Number (Optional)", isDark),
          const SizedBox(height: 5),
          TextField(
            controller: authController.regPolicyNumberController,
            decoration: _inputDecoration(hint: "e.g. HDFC-HLTH-994821", icon: Icons.shield_outlined, isDark: isDark),
          ),
          const SizedBox(height: 14),

          // Password Field
          _buildTextFieldLabel("Password", isDark),
          const SizedBox(height: 5),
          Obx(
            () => TextField(
              controller: authController.regPasswordController,
              obscureText: !authController.isRegPasswordVisible.value,
              decoration: _inputDecoration(
                hint: "Minimum 6 characters",
                icon: Icons.lock_outline_rounded,
                isDark: isDark,
                suffixIcon: IconButton(
                  icon: Icon(
                    authController.isRegPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.primaryTeal,
                    size: 20,
                  ),
                  onPressed: () => authController.toggleRegPasswordVisibility(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Confirm Password Field
          _buildTextFieldLabel("Confirm Password", isDark),
          const SizedBox(height: 5),
          Obx(
            () => TextField(
              controller: authController.regConfirmPasswordController,
              obscureText: !authController.isRegConfirmPasswordVisible.value,
              decoration: _inputDecoration(
                hint: "Re-enter password",
                icon: Icons.lock_reset_rounded,
                isDark: isDark,
                suffixIcon: IconButton(
                  icon: Icon(
                    authController.isRegConfirmPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.primaryTeal,
                    size: 20,
                  ),
                  onPressed: () => authController.toggleRegConfirmPasswordVisibility(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Terms Checkbox
          Row(
            children: [
              Obx(
                () => Checkbox(
                  value: authController.agreeToTerms.value,
                  activeColor: AppColors.primaryTeal,
                  onChanged: (_) => authController.toggleAgreeToTerms(),
                ),
              ),
              Expanded(
                child: Text(
                  "I agree to the Terms of Service & On-Device Privacy Policy",
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Register Button
          Obx(
            () => CustomButton(
              text: "Create Account & Activate Vault",
              icon: Icons.how_to_reg_rounded,
              type: ButtonType.primary,
              isLoading: authController.isLoading.value,
              onPressed: () async {
                await authController.registerAccount();
                if (authController.isLoggedIn.value) {
                  Get.offAll(() => const MainNavigationShell());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // FORGOT PASSWORD STEP 1: Request Code
  Widget _buildForgotPasswordStep1(bool isDark) {
    return AppCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lock_reset_rounded, color: AppColors.accentGold, size: 24),
              SizedBox(width: 10),
              Text(
                "Reset Password",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Enter your registered Email or Phone number to receive a 4-digit verification code.",
            style: TextStyle(
              fontSize: 12.5,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          const SizedBox(height: 20),

          _buildTextFieldLabel("Registered Email or Phone", isDark),
          const SizedBox(height: 6),
          TextField(
            controller: authController.forgotIdentifierController,
            decoration: _inputDecoration(
              hint: "rajesh.kumar@health.in",
              icon: Icons.contact_mail_outlined,
              isDark: isDark,
            ),
          ),
          const SizedBox(height: 22),

          Obx(
            () => CustomButton(
              text: "Send Verification Code",
              icon: Icons.send_rounded,
              type: ButtonType.primary,
              isLoading: authController.isLoading.value,
              onPressed: () => authController.requestPasswordResetOtp(),
            ),
          ),
        ],
      ),
    );
  }

  // FORGOT PASSWORD STEP 2: Verify OTP
  Widget _buildForgotPasswordStep2(bool isDark) {
    return AppCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.pin_outlined, color: AppColors.primaryTeal, size: 24),
              SizedBox(width: 10),
              Text(
                "Enter 4-Digit Code",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "We have sent a verification code to ${authController.forgotIdentifierController.text}.",
            style: TextStyle(
              fontSize: 12.5,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          const SizedBox(height: 20),

          _buildTextFieldLabel("4-Digit OTP Code", isDark),
          const SizedBox(height: 6),
          TextField(
            controller: authController.otpCodeController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 10),
            decoration: _inputDecoration(
              hint: "1234",
              icon: Icons.phonelink_lock_rounded,
              isDark: isDark,
            ),
          ),
          const SizedBox(height: 18),

          Obx(
            () => CustomButton(
              text: "Verify Reset Code",
              icon: Icons.verified_user_rounded,
              type: ButtonType.primary,
              isLoading: authController.isLoading.value,
              onPressed: () => authController.verifyOtpCode(),
            ),
          ),
          const SizedBox(height: 12),

          Center(
            child: TextButton.icon(
              onPressed: () => authController.requestPasswordResetOtp(),
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text("Resend Code", style: TextStyle(fontSize: 12.5)),
            ),
          ),
        ],
      ),
    );
  }

  // FORGOT PASSWORD STEP 3: Set New Password
  Widget _buildForgotPasswordStep3(bool isDark) {
    return AppCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.key_rounded, color: AppColors.protectiveGreen, size: 24),
              SizedBox(width: 10),
              Text(
                "Set New Password",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Enter your new password below.",
            style: TextStyle(
              fontSize: 12.5,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          const SizedBox(height: 20),

          _buildTextFieldLabel("New Password", isDark),
          const SizedBox(height: 6),
          Obx(
            () => TextField(
              controller: authController.newPasswordController,
              obscureText: !authController.isNewPasswordVisible.value,
              decoration: _inputDecoration(
                hint: "Minimum 6 characters",
                icon: Icons.lock_outline_rounded,
                isDark: isDark,
                suffixIcon: IconButton(
                  icon: Icon(
                    authController.isNewPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.primaryTeal,
                    size: 20,
                  ),
                  onPressed: () => authController.toggleNewPasswordVisibility(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          _buildTextFieldLabel("Confirm New Password", isDark),
          const SizedBox(height: 6),
          TextField(
            controller: authController.confirmNewPasswordController,
            obscureText: true,
            decoration: _inputDecoration(
              hint: "Re-enter new password",
              icon: Icons.lock_reset_rounded,
              isDark: isDark,
            ),
          ),
          const SizedBox(height: 22),

          Obx(
            () => CustomButton(
              text: "Update Password & Sign In",
              icon: Icons.check_circle_rounded,
              type: ButtonType.primary,
              isLoading: authController.isLoading.value,
              onPressed: () => authController.resetPasswordWithNew(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    required bool isDark,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primaryTeal, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: isDark ? AppColors.surfaceDark : Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primaryTeal, width: 1.8),
      ),
    );
  }

  Widget _buildSecurityBullet(
    bool isDark, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryTeal.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryTeal, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
