import 'package:flutter/material.dart';
import 'package:okami/theme/app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ 
            Image.asset('assets/images/app_logo.png', width: 180),
            const SizedBox(height: 24),
            Text(
             'ŌKAMI',
             style: Theme.of(context).textTheme.headlineLarge, 
            ) 
          ],
        ),
      ),
    );
  }
}