import 'package:flutter/material.dart';
import 'package:okami/screens/neuroplasticity/edit_task_screen.dart';
import 'package:provider/provider.dart';
import 'package:okami/models/task_model.dart';
import 'package:okami/providers/task_provider.dart';
import 'package:okami/widgets/app_widgets.dart';
import 'week_org_screen.dart';
import 'locking_in_screen.dart';

class NeuPlaScreen extends StatelessWidget {
  const NeuPlaScreen({super.key});

  //Nombres para armar la fecha
  static const List _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const List _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                               'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  //Contiene los elementos de la Screen
  @override
  Widget build(BuildContext context) {
    //Leer tasks del dia
    final now = DateTime.now();
    final todayTasks = context.watch<TaskProvider>().tasksByDay(now);
    
    //Subtitulo para la fecha
    final todayLabel = 'Today · ${_weekDays[now.weekday - 1]}, ${_months[now.month - 1]} ${now.day}';

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
              SectionTitle(title: 'Task Manager', subtitle: todayLabel),

              const SizedBox(height: 20),
              //Botones (LockIN/Org)
              Row(
                children: [
                  Expanded(
                    child: ActionTile(
                      icon: Icons.lock_outline,
                      label: 'Lock in',
                      onTap: () {
                        final task = context.read<TaskProvider>().currentTask();

                        if (task == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No Task currently')),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LockingInScreen(task: task),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  const SizedBox(width: 12),
                  Expanded(
                    child: ActionTile(
                      icon: Icons.edit_attributes_outlined,
                      label: 'Organize my week',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WeekOrgScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              //Lista de Tasks
              Expanded(
                child: todayTasks.isEmpty
                    ? _buildEmptyState(context)
                    : _buildTaskList(context, todayTasks),
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
        return TaskRow(
          task: task,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditTaskScreen(task: task)),
            );
          },
        );
      },
    );
  }

  //Task list (Estado vacio)
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const KanjiWatermark(size: 120),
          const SizedBox(height: 8),
          Text(
            'No tasks yet',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
