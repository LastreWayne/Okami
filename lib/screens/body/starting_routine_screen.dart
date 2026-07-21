import 'package:flutter/material.dart';
import 'package:okami/models/exercise_model.dart';
import 'package:okami/models/routine_model.dart';
import 'package:okami/providers/active_session_provider.dart';
import 'package:okami/providers/workout_provider.dart';
import 'package:okami/utils/string_extensions.dart';
import 'package:provider/provider.dart';
import 'active_routine_screen.dart';

class StartingRoutineScreen extends StatelessWidget {
  final Routine routine;
  const StartingRoutineScreen({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WorkoutProvider>();
    final exercises = routine.exerciseIds
        .map((id) => provider.exerciseById(id))
        .whereType<Exercise>()
        .toList();

    //Logica para organizar ejercicios por categoria y su display
    final Map<ExerciseCategory, int> countByCategory = {};
    for (final e in exercises) {
      countByCategory[e.category] = (countByCategory[e.category] ?? 0) + 1;
    }

    final lines = <String>[];
    for (final category in ExerciseCategory.values) {
      final count = countByCategory[category] ?? 0;
      if (count == 0) continue;
      final noun = count == 1 ? 'Exercise' : 'Exercises';
      lines.add('· $count ${category.name.capitalized} $noun');
    }

    final summary = lines.isEmpty
        ? 'No Exercises yet'
        : lines.join('\n');




    return Scaffold(
      appBar: AppBar(
        title: const Text('Starting Routine'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Spacer(),


            //Texto de la Routine
            Text(
              'Starting the following Routine: ',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            SizedBox(height: 12),

            //Card con la info de la Routine
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      routine.title,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 24),
                    ),

                    SizedBox(height: 8),

                    if (routine.description.isNotEmpty) ...[
                      Text(
                        routine.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],

                    SizedBox(height: 16),

                    Text(
                      summary,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            Spacer(),
            

            //Confirmacion
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  context.read<ActiveSessionProvider>().start(routine, exercises);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActiveRoutineScreen(), 
                    ),
                  );
                },
                icon: const Icon(Icons.bolt_outlined),
                label: const Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 14),
                  child: Text('Start Routine'),
                ),
              ),
            ),

            SizedBox(height: 16)
          ],
        ),
      )
    );
  }
}