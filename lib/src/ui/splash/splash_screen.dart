import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shafmet/src/app_theme/app_colors.dart';
import 'package:shafmet/src/ui/splash/login/login_screen.dart';
import 'package:shafmet/src/ui/splash/main/main_screen.dart';
import 'package:shafmet/src/utilis/cache_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));

    final String token = CacheService.getToken();

    if (!mounted) return;

    if (token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/shafmet.png"),
          ],
        ),
      ),
    );
  }
}