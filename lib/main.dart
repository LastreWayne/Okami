import 'package:flutter/material.dart';
import 'package:okami/theme/app_theme.dart';
import 'package:okami/screens/splash_screen.dart';
import 'package:okami/widgets/app_widgets.dart';

void main() {
  runApp(const OkamiApp());
}

class OkamiApp extends StatelessWidget {
  const OkamiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ōkami',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
