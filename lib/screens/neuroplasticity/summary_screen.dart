import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {
  //Recibir datos de la sesion terminada

  final String taskTitle;
  final int plannedSeconds;
  final int actualSeconds;
  final bool completedFully;

  const SummaryScreen({
    super.key,
    required this.taskTitle,
    required this.plannedSeconds,
    required this.actualSeconds,
    required this.completedFully,
  });

  //Formatear segundos
  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours}h ${mins}min';
  }

  //Estructura de la screen
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              //Cierre
              Icon(
                completedFully ? Icons.check_circle_outline : Icons.flag_outlined,
                size: 72,
                color: Theme.of(context).colorScheme.secondary,
              ),


              const SizedBox(height: 16),
              Text(
                completedFully ? 'Completed Session' : 'Finalized Session',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              //Tarjeta con estadisticas
              const SizedBox(height: 40),

              Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [

                      _buildStatRow(
                        context,
                        icon: Icons.timer_outlined,
                        label: 'Time Planned',
                        value: _formatDuration(plannedSeconds),
                      ),

                      const Divider(height: 14),
                      _buildStatRow(
                        context,
                        icon: Icons.hourglass_bottom,
                        label: 'Time completed',
                        value: _formatDuration(plannedSeconds),
                      ),

                      const Divider(height: 24),
                      _buildStatRow(
                        context,
                        icon: Icons.timer_outlined,
                        label: 'Total completed',
                        value: '${((actualSeconds / plannedSeconds) * 100).round()}%',
                      )
                    ],
                  ),
                ),
              ),

              const Spacer(),

              //Boton para regresar 
              SizedBox(
                width: double.infinity,
                child:  FilledButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Padding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 14),
                    child: Text('Back to Task Manager'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Apoyo para el row
  Widget _buildStatRow(
    BuildContext context, {
      required IconData icon,
      required String label, 
      required String value,
    }) {
      return Row(
        children: [
          Icon(icon, size: 20),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      );
    }
}