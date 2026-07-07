import 'package:flutter/material.dart';
import 'package:okami/widgets/task_form_widgets.dart';
import 'package:provider/provider.dart';
import 'package:okami/models/exercise_model.dart';
import 'package:okami/providers/workout_provider.dart';
import 'package:okami/widgets/app_widgets.dart';
import 'package:okami/widgets/workout_widgets.dart';

class NewExerciseScreen extends StatefulWidget {
  const NewExerciseScreen({super.key});

  @override
  State<NewExerciseScreen> createState() => _NewExerciseScreenState();
}

class _NewExerciseScreenState extends State<NewExerciseScreen> {
  //Controlers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  //Variables para demas parametros de un Exercise
  ExerciseCategory _category = ExerciseCategory.push;
  bool _bodyweight = false;
  int _targetSets = 3;
  int _repsPerSet = 10;

  //Deshacerse de los controles al abandonar
  @override  
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  //Guardar datos del Exercise y mandarlos al provider
  void _saveExercise() {

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to provide a title'))
      );
      return;
    }

    final newExercise = Exercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category,
      bodyweight: _category == ExerciseCategory.cardio ? false : _bodyweight,
      targetSets: _targetSets,
      repsPerSet: _repsPerSet,
    );
    
    //Agregar Exercise al app state
    context.read<WorkoutProvider>().addExercise(newExercise);

    //Cerrar screen
    Navigator.pop(context);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Exercise'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //Titulo
            const FieldLabel('Exercise title'),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'The EXERCISE'),
            ),

            SizedBox(height: 20),

            //Descripcion
            const FieldLabel('Exercise description'),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(hintText: 'Anything specific?'),
            ),

            SizedBox(height: 20),

            //Categoria
            const FieldLabel('Exercise Category'),
            ExerciseCategorySelector(
              value: _category,
              onChanged: (c) => setState(() => _category = c)
            ),

            SizedBox(height: 20),

            //Condicionales para el display de contabilidad segun categoria
            if (_category != ExerciseCategory.cardio) ...[

              //Series
              const FieldLabel('Sets'),
              Center(
                child: NumberStepper(
                  value: _targetSets,
                  onChanged: (v) => setState(() => _targetSets = v)
                ),
              ),

              SizedBox(height: 16),

              //Repeticiones
              const FieldLabel('Reps per set'),
              Center(
                child: NumberStepper(
                  value: _repsPerSet,
                  onChanged: (r) => setState(() => _repsPerSet = r)
                ),
              ),

              SizedBox(height: 20),

              //BodyWeight
              const FieldLabel('BodyWeight'),
              RepeatToggle(
                value: _bodyweight,
                onChanged: (b) => setState(() => _bodyweight = b),
                trueMsg: 'Only bodyweight',
                falseMsg: 'No bodyweight',
              ),
              
            ],

            SizedBox(height: 32),

            //Guardado
            SizedBox(
              width: double.infinity,
              child: GradientButton(label: 'Create Exercise', onPressed: _saveExercise),
            )
          ],
        ),
      ),
    );
  }
}