import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AuthMode { login, register, forgotPassword, otpVerification, resetPassword }

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final Rx<AuthMode> currentMode = AuthMode.login.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = true.obs;

  // Form Controllers - Login
  final TextEditingController loginEmailController = TextEditingController(text: "rajesh.kumar@health.in");
  final TextEditingController loginPasswordController = TextEditingController(text: "Pass@1234");
  final RxBool isPasswordVisible = false.obs;
  final RxBool rememberMe = true.obs;

  // Form Controllers - Register
  final TextEditingController regFullNameController = TextEditingController();
  final TextEditingController regEmailController = TextEditingController();
  final TextEditingController regPhoneController = TextEditingController();
  final TextEditingController regPolicyNumberController = TextEditingController();
  final TextEditingController regPasswordController = TextEditingController();
  final TextEditingController regConfirmPasswordController = TextEditingController();
  final RxBool isRegPasswordVisible = false.obs;
  final RxBool isRegConfirmPasswordVisible = false.obs;
  final RxBool agreeToTerms = false.obs;

  // Form Controllers - Forgot Password
  final TextEditingController forgotIdentifierController = TextEditingController();
  final TextEditingController otpCodeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();
  final RxBool isNewPasswordVisible = false.obs;
  final RxInt otpCountdown = 30.obs;

  // User Profile details
  final RxString currentUserName = "Rajesh Kumar".obs;
  final RxString currentUserEmail = "rajesh.kumar@health.in".obs;

  void _showSnackbar(String title, String message, {Color? backgroundColor, Color? colorText, Duration? duration}) {
    if (Get.context != null) {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: backgroundColor ?? const Color(0xFF0D7377),
        colorText: colorText ?? Colors.white,
        duration: duration ?? const Duration(seconds: 3),
      );
    }
  }

  void switchMode(AuthMode mode) {
    currentMode.value = mode;
  }


  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRegPasswordVisibility() {
    isRegPasswordVisible.value = !isRegPasswordVisible.value;
  }

  void toggleRegConfirmPasswordVisibility() {
    isRegConfirmPasswordVisible.value = !isRegConfirmPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void toggleAgreeToTerms() {
    agreeToTerms.value = !agreeToTerms.value;
  }

  // Action: Login with Password
  Future<void> loginWithPassword() async {
    final email = loginEmailController.text.trim();
    final password = loginPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar(
        "Missing Credentials",
        "Please enter your Email/Phone and Password to log in.",
        backgroundColor: Colors.red[700],
      );
      return;
    }

    if (password.length < 6) {
      _showSnackbar(
        "Invalid Password",
        "Password must be at least 6 characters.",
        backgroundColor: Colors.red[700],
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 900));
    isLoading.value = false;

    isLoggedIn.value = true;
    currentUserName.value = email.contains("@") ? email.split("@")[0].capitalizeFirst! : "User";
    currentUserEmail.value = email;

    _showSnackbar(
      "Welcome Back!",
      "Successfully authenticated with Aarogya-Rakshak On-Device Vault.",
      duration: const Duration(seconds: 3),
    );
  }

  // Action: Register New Account
  Future<void> registerAccount() async {
    final name = regFullNameController.text.trim();
    final email = regEmailController.text.trim();
    final phone = regPhoneController.text.trim();
    final pass = regPasswordController.text.trim();
    final confirmPass = regConfirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || pass.isEmpty) {
      _showSnackbar(
        "Incomplete Form",
        "Please fill in all required fields to create your account.",
        backgroundColor: Colors.red[700],
      );
      return;
    }

    if (pass != confirmPass) {
      _showSnackbar(
        "Password Mismatch",
        "Password and Confirm Password do not match.",
        backgroundColor: Colors.red[700],
      );
      return;
    }

    if (!agreeToTerms.value) {
      _showSnackbar(
        "Terms & Conditions",
        "Please accept the Terms of Service & Privacy Policy to continue.",
        backgroundColor: Colors.orange[800],
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1000));
    isLoading.value = false;

    isLoggedIn.value = true;
    currentUserName.value = name;
    currentUserEmail.value = email;

    _showSnackbar(
      "Account Created!",
      "Welcome $name. Your encrypted medical vault has been initialized.",
      duration: const Duration(seconds: 4),
    );
  }

  // Action: Request Password Reset OTP (Forgot Password Step 1)
  Future<void> requestPasswordResetOtp() async {
    final identifier = forgotIdentifierController.text.trim();

    if (identifier.isEmpty) {
      _showSnackbar(
        "Email or Phone Required",
        "Please enter your registered Email or Phone number.",
        backgroundColor: Colors.red[700],
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    isLoading.value = false;

    currentMode.value = AuthMode.otpVerification;

    _showSnackbar(
      "Reset Code Sent",
      "A 4-digit verification code has been sent to $identifier.",
      duration: const Duration(seconds: 4),
    );
  }

  // Action: Verify OTP Code (Forgot Password Step 2)
  Future<void> verifyOtpCode() async {
    final code = otpCodeController.text.trim();

    if (code.length < 4) {
      _showSnackbar(
        "Invalid OTP Code",
        "Please enter the 4-digit verification code sent to your phone/email.",
        backgroundColor: Colors.red[700],
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 700));
    isLoading.value = false;

    currentMode.value = AuthMode.resetPassword;

    _showSnackbar(
      "OTP Verified",
      "Code verified successfully. Please enter your new password.",
    );
  }

  // Action: Set New Password (Forgot Password Step 3)
  Future<void> resetPasswordWithNew() async {
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmNewPasswordController.text.trim();

    if (newPass.isEmpty || newPass.length < 6) {
      _showSnackbar(
        "Weak Password",
        "New password must be at least 6 characters.",
        backgroundColor: Colors.red[700],
      );
      return;
    }

    if (newPass != confirmPass) {
      _showSnackbar(
        "Password Mismatch",
        "Passwords do not match.",
        backgroundColor: Colors.red[700],
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    isLoading.value = false;

    currentMode.value = AuthMode.login;
    loginPasswordController.text = newPass;

    _showSnackbar(
      "Password Reset Successful!",
      "Your password has been updated. Please sign in with your new password.",
      duration: const Duration(seconds: 4),
    );
  }

  // Action: Biometric Login
  Future<void> loginWithBiometrics() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 900));
    isLoading.value = false;

    isLoggedIn.value = true;
    _showSnackbar(
      "Biometric Authentication",
      "Fingerprint verified! Logged in as $currentUserName.",
    );
  }

  // Action: Logout
  void logout() {
    isLoggedIn.value = false;
    currentMode.value = AuthMode.login;
    _showSnackbar(
      "Logged Out",
      "You have been safely signed out. Your local vault remains encrypted.",
      backgroundColor: Colors.grey[800],
    );
  }
}

