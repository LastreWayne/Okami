import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:okami/theme/app_theme.dart';
import 'package:okami/screens/splash_screen.dart';
import 'package:okami/providers/task_provider.dart';

void main() {
  runApp(const OkamiApp());
}

class OkamiApp extends StatelessWidget {
  const OkamiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: MaterialApp(
        title: 'Ōkami',
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}