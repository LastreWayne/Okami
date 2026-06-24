import 'package:flutter/material.dart';
import 'package:okami/theme/app_theme.dart';
import 'package:okami/widgets/app_widgets.dart';
import 'main_screen.dart';

//Se crea un widget stateful que puede cambiar con el tiempo esto por que lo queremos animar
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
// create state se necesita en un stateful
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// objeto para el estado de la pantalla (animacion)
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

// cronometro de la animacion
  late AnimationController _controller;

// controlar la opacidad del logo
  late Animation<double> _fadeAnimation;

// se ejecuta una sola vez cuando aparece el widget
  @override
  void initState() {
    super.initState();

// Controlador de la animacion
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this
    );

// Estilo de la animacion
    _fadeAnimation = CurvedAnimation(
      parent: _controller, 
      curve: Curves.easeIn,
    );

// Se arranca la animacion
    _controller.forward();

// Despues de 3 segundos se navega a la homescreen
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(

          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }


// Dispose para verrar la animacion
@override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sumi,
      body: Center(
        // FadeTransition usa el valor de _fadeAnimation (0.0 a 1.0)
        // para controlar la opacidad de su hijo
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/app_logo.png',
                width: 160,
              ),
              const SizedBox(height: 28),
              // left pad compensa el espacio final que letterSpacing añade,
              // para que el wordmark quede ópticamente centrado
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text('ŌKAMI', style: Theme.of(context).textTheme.displayLarge),
              ),
              const SizedBox(height: 16),
              const BrushStroke(width: 88, height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
