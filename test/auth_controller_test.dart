import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:aarogya_rakshak/controllers/auth_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthController authController;

  setUp(() {
    Get.testMode = true;
    authController = Get.put(AuthController());
  });

  tearDown(() {
    Get.reset();
  });

  group('AuthController Unit Tests', () {
    test('Initial Auth state is Login mode', () {
      expect(authController.currentMode.value, equals(AuthMode.login));
      expect(authController.isLoggedIn.value, isTrue);
    });

    test('Mode switching works correctly', () {
      authController.switchMode(AuthMode.register);
      expect(authController.currentMode.value, equals(AuthMode.register));

      authController.switchMode(AuthMode.forgotPassword);
      expect(authController.currentMode.value, equals(AuthMode.forgotPassword));
    });

    test('Password visibility toggles', () {
      expect(authController.isPasswordVisible.value, isFalse);
      authController.togglePasswordVisibility();
      expect(authController.isPasswordVisible.value, isTrue);
    });

    test('Login with valid credentials updates user', () async {
      authController.loginEmailController.text = "test.user@aarogya.in";
      authController.loginPasswordController.text = "SecurePass123";

      await authController.loginWithPassword();

      expect(authController.isLoggedIn.value, isTrue);
      expect(authController.currentUserEmail.value, equals("test.user@aarogya.in"));
    });

    test('Forgot Password Step 1 -> Step 2 -> Step 3 Flow', () async {
      authController.forgotIdentifierController.text = "rajesh.kumar@health.in";
      await authController.requestPasswordResetOtp();
      expect(authController.currentMode.value, equals(AuthMode.otpVerification));

      authController.otpCodeController.text = "1234";
      await authController.verifyOtpCode();
      expect(authController.currentMode.value, equals(AuthMode.resetPassword));

      authController.newPasswordController.text = "NewSecurePass123";
      authController.confirmNewPasswordController.text = "NewSecurePass123";
      await authController.resetPasswordWithNew();

      expect(authController.currentMode.value, equals(AuthMode.login));
      expect(authController.loginPasswordController.text, equals("NewSecurePass123"));
    });
  });
}
