import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/app_controller.dart';
import 'screens/splash_onboarding_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
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
      return GetMaterialApp(
        title: 'Aarogya-Rakshak',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: controller.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        home: const SplashOnboardingScreen(),
      );
    });
  }
}
