import 'package:flutter/material.dart';
import 'package:okami/models/task_model.dart';
import 'lock_in_screen.dart';

class LockingInScreen extends StatelessWidget {
  final Task task;
  const LockingInScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final bool isLate = DateTime.now().isAfter(task.dateTime); //Boleano para asegurarse si en el momento la task se empezaria tarde

    return Scaffold(
      appBar: AppBar(
        title: const Text('Locking In'),
      ),

      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            
            //Badge para el isLate
            if (isLate) Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber_rounded, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'LATE!',
                    style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  ),
                ],
              ),
            ),

            //Info de la task
            Text(
              'Entering the following Task: ',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            //Tarjeta con la info de la Task
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    //Titulo de la task y descripcion
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 24),
                    ),

                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        task.description,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],

                    //Datos rapidos (duracion/prioridad)
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfoChip(context, Icons.timer_outlined, '${task.durationMinutes} min'),
                        _buildInfoChip(context, Icons.flag_outlined, '[${task.priority.label}] Priority'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            //Confirmacion
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LockInScreen(task: task), 
                    ),
                  );
                },
                icon: const Icon(Icons.lock_outline),
                label: const Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 14),
                  child: Text('Start session'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Widget de apoyo para mostrar los datos de duracion y prioridad
  Widget _buildInfoChip(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 13))
      ],
    );
  }

}