import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'body_screen.dart';
import 'np_screen.dart';
import 'motion_screen.dart';

// Stateful para la estructura de navegacion
class MainScreen extends StatefulWidget {
  const MainScreen ({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

// indice para saber la screen ubicada
  int _selectedIdx = 0;

  // Lista de las 4 principales screensX
  final List<Widget> _screens = const [
    HomeScreen(),
    BodyScreen(),
    NeuPlaScreen(),
    MotionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIdx,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIdx,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIdx = index;
          });
        },

        destinations: const [
          NavigationDestination(//Boton de la HomeS
            icon: Icon(Icons.home_max_outlined), 
            selectedIcon: Icon(Icons.home), 
            label: 'Home'
          ),
          NavigationDestination(//Boton de la BodyS
            icon: Icon(Icons.fitness_center_outlined), 
            selectedIcon: Icon(Icons.fitness_center), 
            label: 'Body'
          ),
          NavigationDestination(//Boton de la NeuroplasticityS
            icon: Icon(Icons.school_outlined), 
            selectedIcon: Icon(Icons.school), 
            label: 'NeuPlas'
          ),
          NavigationDestination(//Boton de la MotionS
            icon: Icon(Icons.favorite_outline), 
            selectedIcon: Icon(Icons.favorite), 
            label: 'Motion'
          ),
        ],
      ),  
    );
  }
}