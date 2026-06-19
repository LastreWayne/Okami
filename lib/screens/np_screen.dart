import 'package:flutter/material.dart';
import 'week_org_screen.dart';

class NeuPlaScreen extends StatelessWidget {
  const NeuPlaScreen({super.key});

  //Contiene los elementos de la Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //Safe area para el controlar los overflows con los limites del dispositivos
      body: SafeArea(
        //Padding general
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            //Alinea todo
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //TITULO
              Text(
                'Task Manager',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Hoy', //Por ahora pongo esto luego sera la fecha real
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 20),
              //Botones (LockIN/Org)
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      context,
                      icon: Icons.lock_outline,
                      label: 'Lock in',
                      onTap: () {
                        //Por ahora sin funcionalidad, Navega al Locking in Screen
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      context,
                      icon: Icons.edit_attributes_outlined,
                      label: 'Organize my week',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WeekOrgScreen(),
                          ),
                        );
                      }
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              //Lista de Tasks (Por ahora vacia)
              Expanded(
                child: _buildEmptyState(context),
              ),   
            ],
          ),
        ),
      ),
    );
  }

  //Logica funcional de la screen

  //Construir un boton de accion
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      //Caracteristicas del boton
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        //Efecto visual al interactuar con el boton
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            children: [
              Icon(icon, size: 26),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Task list (Estado vacio)
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 56,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks yet — hot reload works! 🐺',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

}