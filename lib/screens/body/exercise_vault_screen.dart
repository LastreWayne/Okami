import 'package:flutter/material.dart';
import 'package:okami/models/exercise_model.dart';
import 'package:okami/providers/workout_provider.dart';
import 'package:okami/screens/body/edit_exercise_screen.dart';
import 'package:okami/screens/body/new_exercise_screen.dart';
import 'package:okami/widgets/app_widgets.dart';
import 'package:okami/widgets/workout_widgets.dart';
import 'package:provider/provider.dart';

class ExerciseVaultScreen extends StatelessWidget {
  const ExerciseVaultScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    final exercises = context.watch<WorkoutProvider>().exercises;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              //Titulo
              SectionTitle(title: 'Exercise Vault', subtitle: 'Your stored heart of a Routine!'),

              SizedBox(height: 20),

              //List view situacional
              Expanded(
                child: exercises.isEmpty
                    ? BuildEmptyState(msg: 'Your Exercise Vault is empty!')
                    : _buildExerciseList(context, exercises)
              ),

              //Boton para crear un nuevo ejercicio
              GradientButton(
                label: 'New Exercise',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewExerciseScreen())
                  );
                }
              )
            ],
          ),
        )
      ),
    );
  }
}

Widget _buildExerciseList(BuildContext context, List<Exercise> exercises) {
  return ListView.builder(
    itemCount: exercises.length,
    itemBuilder: (context, idx) {
      final exercise = exercises[idx];
      return ExerciseCard(
        exercise: exercise,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditExerciseScreen( ))
          );
        },
      );
    }
  );

}

