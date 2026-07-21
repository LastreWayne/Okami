import 'package:flutter/material.dart';
import 'package:okami/models/exercise_model.dart';
import 'package:okami/providers/active_session_provider.dart';
import 'package:okami/providers/workout_provider.dart';
import 'package:okami/widgets/workout_widgets.dart';
import 'package:provider/provider.dart';

class ActiveRoutineScreen extends StatelessWidget {                            
  const ActiveRoutineScreen({super.key});

  //Screen
  @override
  Widget build(BuildContext context) {
    final session = context.watch<ActiveSessionProvider>().session;
    if (session == null) return const Scaffold();

    final workout = context.watch<WorkoutProvider>();
    final exercises = session.exerciseIds
        .map(workout.exerciseById)
        .whereType<Exercise>()
        .toList();

    return Scaffold(
      body: Column(
        children: [

          const SessionHeaderBar(),

          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, i) {
                final ex = exercises[i];
                final sets = session.setsByExercise[ex.id] ?? const [];

                return Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 12, horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ex.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),

                      if (ex.bodyweight) ...[
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('SETS'),
                          Text('REPS'),
                          Container(width: 95,)

                        ],
                      ),

                      ],
                  
                      for (var j = 0; j < sets.length; j++)
                        SetRow(
                          key: ValueKey(sets[j].id),
                          set: sets[j],
                          idx: j,
                          exId: ex.id,
                          bodyweight: ex.bodyweight
                      ),
                    ],
                  ),
                );
              }
            )
          ),

          SizedBox(height: 20)
        ],
      )
    );
  }
}