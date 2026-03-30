import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/routes/route_constants.dart';
import '../../../../../core/widgets/premium_app_bar.dart';
import 'forget_password_listener.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.premiumDarkBackground,
      appBar: PremiumAppBar(
        title: '',
        leading: IconButton(
          icon: Icon(PhosphorIcons.caretLeft(), color: Colors.white),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RouteConstants.login);
            }
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Theme(
        data: AppTheme.darkTheme,
        child: const ForgetPasswordListener(),
      ),
    );
  }
}
