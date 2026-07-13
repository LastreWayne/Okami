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
  final List<TextEditingController> _repsControllers = [];

  //Variables para demas parametros de un Exercise
  ExerciseCategory _category = ExerciseCategory.push;
  bool _bodyweight = false;

  //Estado inicial de controllers de ejercicio
  @override
  void initState() {
    super.initState();
    _repsControllers.addAll(
      List.generate(3, (_) => TextEditingController(text: '10'))
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

  //Guardar datos del Exercise y mandarlos al provider
  void _saveExercise() {

    final reps = _repsControllers //Extrae los datos de los controlers de texto
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
        SnackBar(content: Text('You need to set some reps'))
      );
      return;
    }

    final newExercise = Exercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category,
      bodyweight: _category == ExerciseCategory.cardio ? false : _bodyweight,
      targetReps: _category == ExerciseCategory.cardio ? const [] : reps,
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

              //Series/Reps Table
              const FieldLabel('Exercise Sets/Reps'), 
              Container(
                color: Theme.of(context).colorScheme.onSecondary,
                width: double.infinity,
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('SETS'),
                        Text('REPS'),
                        Container(width: 95,)

                      ],
                    ),

                    SizedBox(height: 16),
                    
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
                        label: const Text('Add Set'),
                      ),
                    ),

                  ]
                )
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