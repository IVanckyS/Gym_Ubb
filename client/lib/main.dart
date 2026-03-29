import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/providers/auth_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
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
  late final AuthProvider _auth;

  @override
  void initState() {
    super.initState();
    _auth = context.read<AuthProvider>();
    _auth.init();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        final router = buildRouter(auth);
        return MaterialApp.router(
          title: 'GymUBB',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          routerConfig: router,
        );
      },
    );
  }
}
