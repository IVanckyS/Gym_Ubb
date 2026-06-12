import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/profile/providers/theme_notifier.dart';
import 'features/profile/providers/weight_unit_notifier.dart';
import 'shared/providers/auth_provider.dart';
import 'shared/providers/onboarding_provider.dart';
import 'shared/providers/default_routine_provider.dart';
import 'shared/services/api_client.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => WeightUnitNotifier()),
        ChangeNotifierProvider(create: (_) => DefaultRoutineProvider()),
      ],
      child: const GymUbbApp(),
    ),
  );
}

class GymUbbApp extends StatefulWidget {
  const GymUbbApp({super.key});

  @override
  State<GymUbbApp> createState() => _GymUbbAppState();
}

class _GymUbbAppState extends State<GymUbbApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthProvider>().init();
    context.read<OnboardingProvider>().init();
    context.read<ThemeNotifier>().init();
    context.read<WeightUnitNotifier>().init();
    context.read<DefaultRoutineProvider>().init();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<AuthProvider, OnboardingProvider, ThemeNotifier>(
      builder: (context, auth, onboarding, themeNotifier, child) {
        final router = buildRouter(auth, onboarding, navigatorKey: navigatorKey);
        return MaterialApp.router(
          title: 'GymUBB',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeNotifier.mode,
          // Toda la app en español: date/time pickers, diálogos, tooltips…
          locale: const Locale('es'),
          supportedLocales: const [Locale('es'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: router,
        );
      },
    );
  }
}
