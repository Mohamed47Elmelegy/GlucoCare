import 'package:flutter/material.dart';
import '../widgets/premium_dashboard_page_body_consumer.dart';

class PremiumDashboardPage extends StatelessWidget {
  const PremiumDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: PremiumDashboardPageBodyConsumer(),
      ),
    );
  }
}
