import 'package:flutter/material.dart';
import 'package:flutter_test_ai/features/auth/presentation/pages/settings_page.dart';
import 'package:flutter_test_ai/features/medication/presentation/pages/medication_history_page.dart';
import 'package:flutter_test_ai/features/medication/presentation/pages/medication_list/medication_list_page.dart';
import 'premium_dashboard/premium_dashboard_page.dart';
import '../widgets/premium_bottom_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const PremiumDashboardPage(),
    const MedicationListPage(),
    const MedicationHistoryPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: PremiumBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
