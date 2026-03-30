import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'core/routes/app_router.dart';
import 'core/services/notification_service.dart';
import 'core/utils/simple_bloc_observer.dart';
import 'features/auth/data/models/user_model.dart';
import 'features/medication/data/models/medication_model.dart';
import 'features/medication/data/models/medication_schedule_model.dart';
import 'features/medication/data/models/dose_history_model.dart';
import 'features/medication/data/models/insulin_reading_model.dart';
import 'features/lab_tests/data/models/lab_test_model.dart';
import 'features/lab_tests/presentation/bloc/lab_test_bloc.dart';

import 'features/medication/presentation/bloc/medication_bloc.dart';
import 'features/medication/presentation/bloc/insulin_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'core/theme/bloc/theme_cubit.dart';
import 'core/localization/bloc/locale_cubit.dart';
import 'injection_container.dart' as di;

import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = SimpleBlocObserver();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(MedicationModelAdapter());
  Hive.registerAdapter(MedicationScheduleModelAdapter());
  Hive.registerAdapter(DoseHistoryModelAdapter());
  Hive.registerAdapter(TimeValueModelAdapter());
  Hive.registerAdapter(InsulinReadingModelAdapter());
  Hive.registerAdapter(LabTestModelAdapter());

  // Dependencies
  await di.init();

  // Initialize Notifications
  await di.sl<NotificationService>().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()..add(AppStarted())),
        BlocProvider(create: (_) => di.sl<MedicationBloc>()),
        BlocProvider(create: (_) => di.sl<InsulinBloc>()),
        BlocProvider(create: (_) => di.sl<LabTestBloc>()),
        BlocProvider(create: (_) => di.sl<ThemeCubit>()),
        BlocProvider(create: (_) => di.sl<LocaleCubit>()),
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
