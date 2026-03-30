import 'package:flutter/material.dart';
import 'login_listener.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.premiumDarkBackground,
      body: Theme(
        data: AppTheme.darkTheme,
        child: const LoginListener(),
      ),
    );
  }
}
