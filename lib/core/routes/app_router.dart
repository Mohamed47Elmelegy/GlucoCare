import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/create_account/create_account_page.dart';
import '../../features/auth/presentation/pages/forget_password/forget_password_page.dart';
import '../../features/home/presentation/pages/main_page.dart';
import '../../features/medication/domain/entities/medication.dart';
import '../../features/medication/presentation/pages/add_medication_page.dart';
import '../../features/medication/presentation/pages/edit_medication_page.dart';
import '../../features/medication/presentation/pages/medication_history/medication_history_page.dart';
import '../../features/medication/presentation/pages/insulin_readings/insulin_readings_page.dart';
import '../../features/lab_tests/presentation/pages/lab_tests/lab_tests_page.dart';
import '../../injection_container.dart';
import '../../features/auth/presentation/pages/edit_profile/edit_profile_page.dart';

import '../utils/go_router_refresh_stream.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import 'route_constants.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteConstants.splash,
  refreshListenable: GoRouterRefreshStream(sl<AuthBloc>().stream),
  redirect: (context, state) {
    final authState = sl<AuthBloc>().state;
    final bool loggingIn =
        state.matchedLocation == RouteConstants.login ||
        state.matchedLocation == RouteConstants.createAccount ||
        state.matchedLocation == RouteConstants.forgetPassword;

    if (authState is AuthLoading || authState is AuthInitial) return null;

    final bool authenticated = authState is AuthSuccess;

    if (!authenticated) {
      if (loggingIn) return null;
      return RouteConstants.login;
    }

    if (loggingIn || state.matchedLocation == RouteConstants.splash) {
      return RouteConstants.home;
    }

    return null;
  },
  routes: [
    // ... existing routes
    GoRoute(
      path: RouteConstants.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: RouteConstants.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RouteConstants.createAccount,
      builder: (context, state) => const CreateAccountPage(),
    ),
    GoRoute(
      path: RouteConstants.forgetPassword,
      builder: (context, state) => const ForgetPasswordPage(),
    ),
    GoRoute(
      path: RouteConstants.home,
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: RouteConstants.dashboard,
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: RouteConstants.addMedication,
      builder: (context, state) => const AddMedicationPage(),
    ),
    GoRoute(
      path: RouteConstants.editMedication,
      builder: (context, state) {
        final medication = state.extra as Medication;
        return EditMedicationPage(medication: medication);
      },
    ),
    GoRoute(
      path: RouteConstants.medicationHistory,
      builder: (context, state) => const MedicationHistoryPage(),
    ),
    GoRoute(
      path: RouteConstants.insulinReadings,
      builder: (context, state) => const InsulinReadingsPage(),
    ),
    GoRoute(
      path: RouteConstants.labTests,
      builder: (context, state) => const LabTestsPage(),
    ),
    GoRoute(
      path: RouteConstants.editProfile,
      builder: (context, state) => const EditProfilePage(),
    ),
  ],
);
