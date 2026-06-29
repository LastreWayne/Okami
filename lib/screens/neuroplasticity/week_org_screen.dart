import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:okami/models/task_model.dart';
import 'package:okami/providers/task_provider.dart';
import 'new_task_screen.dart';
import 'edit_task_screen.dart';
import 'package:okami/theme/app_theme.dart';

class WeekOrgScreen extends StatelessWidget {
  const WeekOrgScreen ({super.key});
  
  //Lista de los dias
  static const List<String> _dayNames = [
    'Mon', 'Tue', 'Wen', 'Thu', 'Fri', 'Sat', 'Sun'
  ];

  List<DateTime> _weekDays() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    
    //Generar las fechas consecutivas despues del Lunes (la semana(7))
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  // Constructor de las tabs
  @override
  Widget build(BuildContext context) {
    final weekDays = _weekDays();
    final todayIdx = DateTime.now().weekday - 1;

    //Tabs por dia de la semana
    return DefaultTabController(
      length: 7,
      initialIndex: todayIdx,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Organize my week'),
          bottom: TabBar(
            isScrollable: false,
            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
            tabs: List.generate(
              7,
              (i) => Tab(text: '${_dayNames[i]} ${weekDays[i].day}',)
            ),
          ),
        ),

        //Mostrar el contenido de las tabs
        body: TabBarView(
          children: weekDays.map((day) => _DayTaskView(day: day)).toList(),
        ),

        //Boton para la nueva Task
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewTaskScreen(),
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('New Task'),
        ),
      ),
    );
  }
}

//Vista individual de un dia
class _DayTaskView extends StatelessWidget {
  final DateTime day;
  const _DayTaskView({required this.day});

  @override  
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().tasksByDay(day);

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_available_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)
            ),

            const SizedBox(height: 12),
            Text(
              'No Tasks for this day',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, idx) {
        final task = tasks[idx];
        return _TaskCard(task: task);
      },
    );
  }
}

//Card individual de una Task dentro de la lista del dia
class _TaskCard extends StatelessWidget {
  final Task task;
  const _TaskCard({required this.task});

  //Color del badge segun la prioridad
  Color get _priorityColor {
    switch (task.priority) {
      case TaskPriority.a:
        return AppColors.priorityA;
      case TaskPriority.b:
        return AppColors.priorityB;
      case TaskPriority.c:
        return AppColors.priorityC;
    }
  }

  //Nombre legible de la categoria
  String _categoryLabel() {
    switch (task.category) {
      case TaskCategory.body:
        return 'Body';
      case TaskCategory.neuroplasticity:
        return 'Neuroplasticity';
      case TaskCategory.motion:
        return 'Motion';
    }
  }

  //Hora con zero-padding (HH:MM)
  String _formatTime() {
    final h = task.dateTime.hour.toString().padLeft(2, '0');
    final m = task.dateTime.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: task.isLocked ? 0.5 : 1.0,
      
      child: Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        //Badge de prioridad (A/B/C)
        leading: CircleAvatar(
          backgroundColor: _priorityColor,
          child: Text(
            task.priority.name.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        //Titulo de la task
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),

        //Hora, duracion y categoria
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${_formatTime()}  ·  ${task.durationMinutes.asDuration}  ·  ${_categoryLabel()}',
          ),
        ),

        //Indicador de estado y repeticion
        trailing: task.isLocked
          ? Icon(task.status == TaskStatus.completed ? Icons.check_circle : Icons.flag_outlined,
             size: 30,
             color: task.status == TaskStatus.completed ? AppColors.ultramarine : AppColors.inkFaint,
          )
          : (task.repeatsWeekly ? Icon(Icons.repeat, size: 30, color: Theme.of(context).colorScheme.secondary) : null
          ),

        //Tocar la card abre la edicion de esa task
        onTap: task.isLocked ? null : () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditTaskScreen(task: task),
            ),
          );
        },
      ),
    )
   );
  }
}
