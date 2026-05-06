import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pwms_frontend/core/di/injection.dart';
import 'package:pwms_frontend/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  await setupLocator();
  runApp(const ProviderScope(child: PWMSApp()));
}

class PWMSApp extends StatelessWidget {
  const PWMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = getIt<GoRouter>();

    return MaterialApp.router(
      title: 'PWMS PDA',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
    );
  }
}
