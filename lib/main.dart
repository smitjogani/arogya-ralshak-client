import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controllers/app_controller.dart';
import 'screens/splash_onboarding_screen.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialize GetX AppController
  Get.put(AppController());

  runApp(const AarogyaRakshakApp());
}

class AarogyaRakshakApp extends StatelessWidget {
  const AarogyaRakshakApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();

    return Obx(() {
      final isDark = controller.isDarkMode.value;

      // Dynamic System UI Overlay for iOS Status Bar & Android Nav Bar
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          systemNavigationBarColor:
              isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          systemNavigationBarIconBrightness:
              isDark ? Brightness.light : Brightness.dark,
        ),
      );

      return GetMaterialApp(
        title: 'Aarogya-Rakshak',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        home: const SplashOnboardingScreen(),
      );
    });
  }
}
