import 'package:flutter/material.dart';
import 'package:okami/screens/neuroplasticity/edit_task_screen.dart';
import 'package:provider/provider.dart';
import 'package:okami/models/task_model.dart';
import 'package:okami/providers/task_provider.dart';
import 'week_org_screen.dart';
import 'locking_in_screen.dart';

class NeuPlaScreen extends StatelessWidget {
  const NeuPlaScreen({super.key});

  //Contiene los elementos de la Screen
  @override
  Widget build(BuildContext context) {
    //Leer tasks del dia 
    final todayTasks = context.watch<TaskProvider>().tasksByDay(DateTime.now());


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
                'Today',
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
                        final task = context.read<TaskProvider>().currentTask();

                        if (task == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No Task planned currently')),
                          );
                        } else {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => LockingInScreen(task: task)),
                          );
                        }
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

              //Lista de Tasks
              Expanded(
                child: todayTasks.isEmpty ? _buildEmptyState(context) : _buildTaskList(context, todayTasks),
              ),   
            ],
          ),
        ),
      ),
    );
  }

  //Logica funcional de la screen
 Widget _buildTaskList(BuildContext context, List<Task> tasks) {
  return ListView.builder(
    itemCount: tasks.length,
    itemBuilder: (context, idx) {
      final task = tasks[idx];
      return Card(
        child: ListTile(
          leading: CircleAvatar(
            child: Text(task.priority.name.toUpperCase()),
          ),
          title: Text(task.title),
          subtitle: Text(
            '${_formatHour(task.dateTime)} · ${task.durationMinutes} min',
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditTaskScreen(task: task))
            );
          },
        ),
      );
    },
  );
 }

 String _formatHour(DateTime dt) {
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m';
 }






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
            'No tasks yet',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

}
