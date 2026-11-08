import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/app_bootstrap.dart';
import 'core/routes/app_router.dart';
import 'core/services/notification_action_handler.dart';
import 'core/services/notification_service.dart';
import 'core/utils/simple_bloc_observer.dart';
import 'features/lab_tests/presentation/cubit/lab_test_cubit.dart';
import 'features/medication/presentation/cubit/intake_cubit.dart';
import 'features/medication/presentation/cubit/medication_cubit.dart';
import 'features/medication/presentation/cubit/insulin_cubit.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'core/theme/bloc/theme_cubit.dart';
import 'core/localization/bloc/locale_cubit.dart';
import 'core/di/injection_container.dart' as di;

import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase, Hive adapters and dependencies (shared with the background
  // notification isolate).
  await bootstrapApp();
  Bloc.observer = SimpleBlocObserver();

  // Initialize Notifications
  final notificationService = di.sl<NotificationService>();
  await notificationService.initialize();
  NotificationActionHandler.listenInMainIsolate();

  // A Taken/Snooze tap that launched the app is applied before the UI loads
  // today's doses, so the first render already reflects it.
  final launchResponse = await notificationService.getLaunchResponse();
  if (launchResponse != null) {
    await NotificationActionHandler.handleAction(
      actionId: launchResponse.actionId,
      taskId: launchResponse.payload,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()..checkAuthStatus()),
        BlocProvider(create: (_) => di.sl<MedicationCubit>()),
        BlocProvider(create: (_) => di.sl<InsulinCubit>()),
        BlocProvider(create: (_) => di.sl<LabTestCubit>()),
        BlocProvider(create: (_) => di.sl<ThemeCubit>()),
        BlocProvider(create: (_) => di.sl<LocaleCubit>()),
        BlocProvider(
          create: (_) => di.sl<IntakeCubit>()
            ..loadTasks(date: DateTime.now()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp.router(
                locale: locale,
                onGenerateTitle: (context) =>
                    AppLocalizations.of(context)!.appTitle,
                debugShowCheckedModeBanner: false,
                routerConfig: appRouter,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [Locale('en'), Locale('ar')],
              );
            },
          );
        },
      ),
    );
  }
}

///Always follow the rules defined in docs/app-architecture.md, docs/flutter_skill.md and docs/ui_ux_skill.md.
