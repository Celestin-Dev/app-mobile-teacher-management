// app.dart
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/routeur/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'ENI Teacher Manager',
    theme: AppTheme.light,
    routerConfig: appRouter,
    debugShowCheckedModeBanner: false,
  );
}
