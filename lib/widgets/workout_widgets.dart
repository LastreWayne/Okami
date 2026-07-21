import 'package:flutter/material.dart';
import 'package:okami/models/exercise_model.dart';
import 'package:okami/models/routine_model.dart';
import 'package:okami/models/workout_session_model.dart';
import 'package:okami/providers/active_session_provider.dart';
import 'package:okami/theme/app_theme.dart';
import 'package:okami/widgets/app_widgets.dart';
import 'dart:async';

import 'package:provider/provider.dart';


//WIDGETS DE EJERCICIOS

//Tarjeta visualizadora de un ejercicio
class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback? onTap;
  final Widget? trailing;

  const ExerciseCard({
    super.key,
    required this.exercise,
    this.onTap,
    this.trailing
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: InkCard(

        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  Text(
                    _summary,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              )
            ),

            trailing ?? Icon(Icons.chevron_right, color: AppColors.inkFaint,)
          ],
        ),
      )
    );
  }

  //Getter de los datos de los datos extra de un ejercio
  String get _summary {
    final cat = exercise.category.name;

    if (exercise.category == ExerciseCategory.cardio) return '$cat · Timed';
    final bw = exercise.bodyweight ? ' · BW' : '';

    return '$cat · ${exercise.targetReps.join(' | ')}$bw';
  }

}


//Selector de categoria

class ExerciseCategorySelector extends StatelessWidget {
  final ExerciseCategory value;
  final ValueChanged<ExerciseCategory> onChanged;

  const ExerciseCategorySelector({
    super.key,
    required this.value,
    required this.onChanged
  });

  //Helper para el display de nombres
  String _label(ExerciseCategory cat) {
    switch (cat) {
      case ExerciseCategory.cardio:
        return 'Cardio';
      case ExerciseCategory.pull:
        return 'Pull';
      case ExerciseCategory.push:
        return 'Push';
      case ExerciseCategory.resistance:
        return 'Resistance';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: ExerciseCategory.values.map((cat) {
        return ChoiceChip(
          label: Text(_label(cat)),
          selected: value == cat,
          onSelected: (_) => onChanged(cat),
        );
      }).toList(),
    );
  }
}


//WIDGETS DE RUTINAS

//Tarjeta visualizadora de una rutina
class RoutineCard extends StatelessWidget {
  final Routine routine;
  final VoidCallback? onTap;
  final VoidCallback onPressed;

  const RoutineCard({
    super.key,
    required this.routine,
    this.onTap,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: 20),
      child: InkCard(
        onTap: onTap,
        child: Row(
          children: [
            
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //Datos de la rutina
                    Text(//Titulo
                      routine.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(//Descripcion
                      routine.description,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(//Total de ejercicios dentro de la rutina
                      '· ${routine.exerciseIds.length} Exercise${routine.exerciseIds.length == 1 ? '' : 's'}',
                      style: Theme.of(context).textTheme.labelMedium,
                    )

                  ],
                ),
              ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(//Boton para iniciar la rutina
                width: 128,
                child: GradientButton(
                  label: 'Start Routine',
                  onPressed: onPressed
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//SESION ACTIVA

class SessionTimer extends StatefulWidget {
  const SessionTimer({super.key});

  @override  
  State<SessionTimer> createState() => _SessionTimerState();
}

class _SessionTimerState extends State<SessionTimer> {
  Timer? _ticker;

  @override  
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  @override  
  void dispose() {
    _ticker?.cancel();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final elapsed = context.watch<ActiveSessionProvider>().elapsed;
    return Text(
      _formatTime(elapsed.inSeconds),
      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: Colors.white),
    );
  }
}



class SessionHeaderBar extends StatelessWidget {
  const SessionHeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ActiveSessionProvider>();

    return SafeArea(
      bottom: false,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            IconButton(
              onPressed: () {
                //TODO minimize
              },
              icon: const Icon(Icons.close_fullscreen)
            ),

            const SessionTimer(),

            Padding(
              padding: EdgeInsetsGeometry.directional(end: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${provider.completedExercises}/${provider.totalExercises} Exercises',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 8),

                  SizedBox(
                    width: 100,
                    child: LinearProgressIndicator(value: provider.progress),
                  )
                ],
              )
            )
          ],
        ),
      )
    );
  }
}



class SetRow extends StatelessWidget {
  final PerformedSet set;
  final int idx;
  final String exId;
  final bool bodyweight;

  const SetRow({
    super.key,
    required this.set,
    required this.idx,
    required this.exId,
    required this.bodyweight,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ActiveSessionProvider>();

    return Padding(
      padding:EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          
          Text('${idx + 1}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),),

          SizedBox(
            width: 64,
            height: 42,
            child: TextFormField(
              initialValue: set.reps.toString(),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              onChanged: (val) => provider.updateReps(exId, idx, int.tryParse(val) ?? 0),
            ),
          ),

          if (!bodyweight)
            SizedBox(
              width: 72,
              height: 42,
              child: TextFormField(
                initialValue: set.weight?.toString() ?? '',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                onChanged: (val) => provider.updateWeight(exId, idx, double.tryParse(val)),
              ),
            ),

          Checkbox(
            value: set.done,
            onChanged: (val) => provider.toggleSet(exId, idx, val ?? false)
          )
        ],
      ) 
    );
  }
}




