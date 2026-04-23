import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/services/secure_storage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2500), _checkAuth);
  }

  Future<void> _checkAuth() async {
    if (!mounted) return;
    final token = await SecureStorageService.getToken();
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      token != null ? AppRouter.dashboard : AppRouter.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // ── Logo dari file asset (di tengah layar) ────
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/logo_splash.png',
                width: 180,
                height: 180,
              ),
            ),
          ),

          // ── Teks "HomeLiving" di bawah (sesuai referensi) ─
          const Padding(
            padding: EdgeInsets.only(bottom: 52),
            child: Text(
              'HomeLiving',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
