import 'package:flutter/material.dart';
import 'package:okami/models/exercise_model.dart';
import 'package:okami/widgets/task_form_widgets.dart';
import 'package:provider/provider.dart';
import 'package:okami/models/routine_model.dart';
import 'package:okami/providers/workout_provider.dart';
import 'package:okami/widgets/app_widgets.dart';
import 'package:okami/widgets/workout_widgets.dart';
import 'edit_exercise_screen.dart';
import 'exercise_vault_screen.dart';

class NewRoutineScreen extends StatefulWidget {
  const NewRoutineScreen({super.key});

  @override
  State<NewRoutineScreen> createState() => _NewRoutineScreenState();
}

class _NewRoutineScreenState extends State<NewRoutineScreen> {
  //Controlers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  //Lista de ejercicios
  final List<String> _selectedIds = [];

  //Deshacerse de los controles al abandonar
  @override  
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  //Guardar datos de la Routine y mandarlos al provider
  void _saveRoutine() {
    final provider = context.read<WorkoutProvider>();

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to provide a title'))
      );
      return;
    }

    if (_selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one Exercise'))
      );
      return;
    }

    final newRoutine = Routine(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      exerciseIds: _selectedIds
           .where((id) => provider.exerciseById(id) != null)
           .toList()
    );
    
    //Agregar Exercise al app state
    context.read<WorkoutProvider>().addRoutine(newRoutine);

    //Cerrar screen
    Navigator.pop(context);
  }

  //Metodo para recibir los datos de seleccionar los ejercicios en el vault
  Future<void> _pickExercises() async {
    final picked = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(builder: (_) => const ExerciseVaultScreen(selecting: true)),
    );

    if (!mounted || picked == null || picked.isEmpty) return;

    setState(() => _selectedIds.addAll(picked));
  }
 

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();
    final selected = _selectedIds
        .map(provider.exerciseById)
        .whereType<Exercise>()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Routine'),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //Titulo
              const FieldLabel('Routine Title'),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'The ROUTINE'),
              ),

              SizedBox(height: 20),

              //Descripcion
              const FieldLabel('Routine Description'),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(hintText: 'How will you train?'),
              ),

              SizedBox(height: 20),

              //List view situacional
              const FieldLabel('Selected Exercises'),
              Expanded(
                child: _selectedIds.isEmpty
                    ? BuildEmptyState(msg: 'Add your Exercises')
                    : _buildExerciseList(context, selected)
              ),

              const SizedBox(height: 32),

              //Agregar ejercicios
              SizedBox(
                width: double.infinity,
                child: GradientButton(label: 'Add Exercises', onPressed: _pickExercises),
              ),

              SizedBox(height: 12),

              //Guardado
              SizedBox(
                width: double.infinity,
                child: GradientButton(label: 'Create Routine', onPressed: _saveRoutine),
              )
            ],
          ),
        )
      )
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
          trailing: IconButton(
            onPressed: () => setState(() => _selectedIds.removeAt(idx)),
            icon:  Icon(Icons.close),
          ),
        );
      }
    );
  }

  
}