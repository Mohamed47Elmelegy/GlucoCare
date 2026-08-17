import 'package:flutter/material.dart';
import 'login_listener.dart';
import '../../../../../core/constants/app_colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: LoginListener(),
    );
  }
}
