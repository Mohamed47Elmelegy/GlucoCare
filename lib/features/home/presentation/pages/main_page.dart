import 'package:flutter/material.dart';
import 'package:flutter_test_ai/features/medication/presentation/pages/medication_list/medication_list_page.dart';
import 'package:flutter_test_ai/features/medication/presentation/pages/insulin_readings/insulin_readings_page.dart';
import 'package:flutter_test_ai/features/appointments/presentation/pages/doctor_follow_up_page.dart';
import 'package:flutter_test_ai/features/lab_tests/presentation/pages/lab_tests_page.dart';
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
    const InsulinReadingsPage(),
    const DoctorFollowUpPage(),
    const LabTestsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
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
