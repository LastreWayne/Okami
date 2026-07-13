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
  final List<TextEditingController> _repsControllers = [];

  //Variables para demas parametros de un Exercise
  late ExerciseCategory _category;
  late bool _bodyweight;

  //Cargar los datos del Exercise ya existente
  @override
  void initState() {
    super.initState();
    final exercise = widget.exercise;
    _titleController = TextEditingController(text: exercise.title);
    _descriptionController = TextEditingController(text: exercise.description);
    _category = exercise.category;
    _bodyweight = exercise.bodyweight;
    _repsControllers.addAll(
      exercise.targetReps.map((r) => TextEditingController(text: r.toString()))
    );
  }

  //Deshacerse de los controles al abandonar
  @override  
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (final c in _repsControllers) {
      c.dispose();
    }
    super.dispose();
  }

  //Exercise table
  void _addSet() {
    final seed = _repsControllers.isEmpty ? '10' : _repsControllers.last.text;
    setState(() => _repsControllers.add(TextEditingController(text: seed)));
  }

  void _removeRow(int i) {
    setState(() => _repsControllers.removeAt(i).dispose());
  }

  //Guardar cambios del Exercise y mandarlos al provider
  void _saveChanges() {
    final reps = _repsControllers
      .map((c) => int.tryParse(c.text.trim()) ?? 0)
      .toList();

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to provide a title'))
      );
      return;
    }

    if (_category != ExerciseCategory.cardio && 
    (reps.isEmpty || reps.any((r) => r < 1))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Set some reps first'))
      );
      return;
    }

    final updatedExercise =  widget.exercise.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category,
      bodyweight: _category == ExerciseCategory.cardio ? false : _bodyweight,
      targetReps: _category == ExerciseCategory.cardio ? const [] : reps
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
            const FieldLabel('Exercise Title'),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'The EXERCISE'),
            ),

            SizedBox(height: 20),

            //Descripcion
            const FieldLabel('Exercise Description'),
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

              //Series/Reps Table
              Container(
                color: Theme.of(context).colorScheme.onSecondary,
                width: double.infinity,
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('SET'),
                        Text('REPS'),
                        Container(width: 95,)
                      ],
                    ),
                    
                    ...List.generate(_repsControllers.length, (i) => Padding(
                      padding: EdgeInsetsGeometry.symmetric(vertical: 4),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text(
                            'Set ${i + 1}'
                            ),
                          

                            SizedBox(
                              width: 80,
                              height: 50,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,                             
                                controller: _repsControllers[i],
                              ),
                            ),
                      
                            IconButton.filled(
                              onPressed: () => _removeRow(i),
                              icon: Icon(Icons.delete),
                              highlightColor: Theme.of(context).colorScheme.error,
                            )

                          ],
                        ),
                      )
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: _addSet,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Set')
                      ),
                    ),

                  ]
                )
              ),

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