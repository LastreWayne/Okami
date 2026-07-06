import 'package:flutter/material.dart';
import 'package:okami/models/exercise_model.dart';
import 'package:okami/models/routine_model.dart';
import 'package:okami/theme/app_theme.dart';
import 'package:okami/widgets/app_widgets.dart';


//WIDGETS DE EJERCICIOS

//Tarjeta visualizadora de un ejercicio
class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback? onTap;

  const ExerciseCard({
    super.key,
    required this.exercise,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkCard(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 12),
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

            Icon(Icons.chevron_right, color: AppColors.inkFaint,)
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

    return '$cat · ${exercise.targetSets} x ${exercise.repsPerSet}$bw';
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
                      'Example Routine',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(//Descripcion
                      'Example description',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(//Total de ejercicios dentro de la rutina
                      '10 Exercises',
                      style: Theme.of(context).textTheme.labelMedium,
                    )

                  ],
                ),
              ),

            SizedBox(//Boton para iniciar la rutina
              width: 128,
              child: GradientButton(
                label: 'Start Routine',
                onPressed: onPressed
              ),
            )
          ],
        ),
      ),
    );
  }
}