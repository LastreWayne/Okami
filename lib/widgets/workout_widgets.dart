import 'package:flutter/material.dart';
import 'package:okami/models/exercise_model.dart';
import 'package:okami/theme/app_theme.dart';
import 'package:okami/widgets/app_widgets.dart';

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