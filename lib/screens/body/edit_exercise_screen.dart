import 'package:flutter/material.dart';
import 'package:okami/widgets/task_form_widgets.dart';
import 'package:provider/provider.dart';
import 'package:okami/models/exercise_model.dart';
import 'package:okami/providers/workout_provider.dart';
import 'package:okami/widgets/app_widgets.dart';
import 'package:okami/widgets/workout_widgets.dart';

class EditExerciseScreen extends StatefulWidget {
  final Exercise exercise;
  const EditExerciseScreen({super.key, required this.exercise});

  @override
  State<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
  //Controlers
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  //Variables para demas parametros de un Exercise
  late ExerciseCategory _category;
  late bool _bodyweight;
  late int _targetSets;
  late int _repsPerSet;

  //Cargar los datos del Exercise ya existente
  @override
  void initState() {
    super.initState();
    final exercise = widget.exercise;
    _titleController = TextEditingController(text: exercise.title);
    _descriptionController = TextEditingController(text: exercise.description);
    _category = exercise.category;
    _bodyweight = exercise.bodyweight;
    _targetSets = exercise.targetSets;
    _repsPerSet = exercise.repsPerSet;
  }

  //Deshacerse de los controles al abandonar
  @override  
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  //Guardar cambios del Exercise y mandarlos al provider
  void _saveChanges() {

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to provide a title'))
      );
      return;
    }

    final updatedExercise =  widget.exercise.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category,
      bodyweight: _bodyweight,
      targetSets: _targetSets,
      repsPerSet: _repsPerSet,
    );
    
    //Agregar Exercise al app state
    context.read<WorkoutProvider>().updateExercise(updatedExercise);

    //Cerrar screen
    Navigator.pop(context);
  }

  //Elimina el Exercise del app state
  void _deleteExercise() {
    context.read<WorkoutProvider>().deleteExercise(widget.exercise.id);
    Navigator.pop(context);
    Navigator.pop(context);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Exercise'),
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

            const SizedBox(height: 20),

            //Categoria
            const FieldLabel('Exercise Category'),
            ExerciseCategorySelector(
              value: _category,
              onChanged: (c) => setState(() => _category = c)
            ),

            const SizedBox(height: 20),

            //Condicionales para el display de contabilidad segun categoria
            if (_category != ExerciseCategory.cardio) ...[

              //Series
              const FieldLabel('Sets'),
              NumberStepper(
                value: _targetSets,
                onChanged: (v) => setState(() => _targetSets = v)
              ),

              const SizedBox(height: 16),

              //Repeticiones
              const FieldLabel('Reps per set'),
              NumberStepper(
                value: _repsPerSet,
                onChanged: (r) => setState(() => _repsPerSet = r)
              ),

              const SizedBox(height: 20),

              //BodyWeight
              const FieldLabel('BodyWeight'),
              RepeatToggle(
                value: _bodyweight,
                onChanged: (b) => setState(() => _bodyweight = b),
                trueMsg: 'Only bodyweight',
                falseMsg: 'No bodyweight',
              ),
              
            ],

            const SizedBox(height: 32),

            //Guardado
            SizedBox(
              width: double.infinity,
              child: GradientButton(label: 'Save Changes', onPressed: _saveChanges),
            ),

            const SizedBox(height: 12),

            //Eliminar el Exercise
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showDeleteConfirmation(context);
                },
                icon: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                label: Text(
                  'Delete Exercise',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.error
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  //Mensaje de cofirmacion (delete)
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Exercise?'),
        content: const Text('This action can not be undone'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')
          ),
          TextButton(
            onPressed: _deleteExercise,
            child: Text(
              'Delete',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            )
          ),
        ],
      )
    );
  }
}