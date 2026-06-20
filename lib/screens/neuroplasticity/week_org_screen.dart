import 'package:flutter/material.dart';
import 'new_task_screen.dart';

class WeekOrgScreen extends StatelessWidget {
  const WeekOrgScreen ({super.key});
  
  //Lista de los dias
  static const List<String> _days = [
    'Mon', 'Tue', 'Wen', 'Thu', 'Fri', 'Sat', 'Sun'
  ];

  // Constructor de las tabs
  @override
  Widget build(BuildContext context) {
    //Tabs por dia de la semana
    return DefaultTabController(
      length: _days.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Organize my week'),
          bottom: TabBar(
            isScrollable: false,
            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
            tabs: _days.map((day) => Tab(text: day)).toList(),
          ),
        ),

        //Mostrar el contenido de las tabs
        body: TabBarView(
          children: _days.map((day) => _buildDayView(context, day)).toList(),
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
          label: const Text('NewTask'),
        ),
      ),
    );
  }

  //Vista individual de un dia
  Widget _buildDayView(BuildContext context, String day) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),

          const SizedBox(height: 12),
          Text(
            'No Tasks for $day',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}