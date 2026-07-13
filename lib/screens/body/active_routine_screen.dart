import 'package:flutter/material.dart';
import 'package:okami/models/exercise_model.dart';
import 'package:okami/models/routine_model.dart';
import 'dart:async';
import 'package:okami/models/workout_session_model.dart';
import 'package:okami/providers/workout_provider.dart';
import 'package:provider/provider.dart';

class ActiveRoutineScreen extends StatefulWidget {
  final Routine routine;
  const ActiveRoutineScreen({super.key, required this.routine});

  @override
  State<ActiveRoutineScreen> createState() => _ActiveRoutineScreenState();
}

class _ActiveRoutineScreenState extends State<ActiveRoutineScreen> {

  //Datos de la rutina
  late final List<Exercise> _exercises;
  late final Map<String, List<PerformedSet>> _setsByExercise;

  //Manejo del timer
  int _elapsedSeconds = 0;
  Timer? _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsedSeconds ++);
    });
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60; //division entera
    final secs = seconds % 60; //mod

    if (seconds >= 3600) {
      return '${hours.toString()}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    else {
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}'; //formateo MM:SS
    }
    
  }

  //Estado inicial
  @override
  void initState() {
    super.initState();
    final provider = context.read<WorkoutProvider>();

    _exercises = widget.routine.exerciseIds 
        .map((id) => provider.exerciseById(id))
        .whereType<Exercise>()
        .toList();

    _setsByExercise = {
      for (final ex in _exercises)
        ex.id: List.generate(
          ex.targetReps.length,
          (i) => PerformedSet(reps: ex.targetReps[i])
        )
    };

    _startTimer();
  }
  
  //Deshacer
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  //Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            const SizedBox(height: 30),
            //Titulo de la Routine
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                widget.routine.title,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 20),
                ),
                Text(
                '- Log Workout',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 16),
                ),
              ],
            ),
            
            

            //Container fijo con timer y desc
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.secondary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      Text(
                        _formatTime(_elapsedSeconds),
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
                      ),

                      Text(
                        '50% COMPLETED'
                      ),
                      

                  ],
                ),
              ),
            ),

            //Lisview con los ejercicios
            


          ],
        ),
      ),
    );
  }

}