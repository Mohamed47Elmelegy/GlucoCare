import 'package:flutter/material.dart';
import 'premium_dashboard_listener.dart';

class PremiumDashboardPage extends StatelessWidget {
  const PremiumDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: PremiumDashboardListener(),
      ),
    );
  }
}
