import 'package:flutter/material.dart';
import 'package:okami/models/exercise_model.dart';
import 'package:okami/providers/workout_provider.dart';
import 'package:okami/screens/body/edit_exercise_screen.dart';
import 'package:okami/screens/body/new_exercise_screen.dart';
import 'package:okami/widgets/app_widgets.dart';
import 'package:okami/widgets/workout_widgets.dart';
import 'package:provider/provider.dart';

class ExerciseVaultScreen extends StatefulWidget {
  final bool selecting;
  const ExerciseVaultScreen({super.key, this.selecting = false});

  @override
  State<ExerciseVaultScreen> createState() => _ExerciseVaultScreenState();
}

class _ExerciseVaultScreenState extends State<ExerciseVaultScreen> {
  final Set<String> _checkedIds = {};

  @override
  Widget build(BuildContext context) {


    final exercises = context.watch<WorkoutProvider>().exercises;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Titulo
              const SectionTitle(title: 'Exercise Vault', subtitle: 'Your stored heart of a Routine!'),

              const SizedBox(height: 20,),

              //List view situacional
              Expanded(
                child: exercises.isEmpty
                    ? BuildEmptyState(msg: 'Your Exercise Vault is empty!')
                    : _buildExerciseList(context, exercises)
              ),

              const SizedBox(height: 20),

              //Boton para crear un nuevo ejercicio
              GradientButton(
                label: 'New Exercise',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewExerciseScreen())
                  );
                }
              ),

              //Boton de agregar ejercicios (en selection mode)
              if (widget.selecting && _checkedIds.isNotEmpty) ...[
                SizedBox(height: 12),
                GradientButton(
                  label: 'Add ${_checkedIds.length} Exercises',
                  onPressed: () => Navigator.pop(context, _checkedIds.toList()),
                ),
              ],

            ],
          ),
        )
      ),
    );
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
              MaterialPageRoute(builder: (context) => EditExerciseScreen(exercise: exercise))
            );
          },
          trailing: widget.selecting
              ? Checkbox(
                  value: _checkedIds.contains(exercise.id),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        _checkedIds.add(exercise.id);
                      } else {
                        _checkedIds.remove(exercise.id);
                      }
                    });
                  },
                )
              : null,
        );
      }
    );
  }
}



  

