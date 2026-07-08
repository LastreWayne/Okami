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

class EditRoutineScreen extends StatefulWidget {
  final Routine routine;
  const EditRoutineScreen({super.key, required this.routine});

  @override
  State<EditRoutineScreen> createState() => _EditRoutineScreenState();
}

class _EditRoutineScreenState extends State<EditRoutineScreen> {
  //Controlers
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  //Lista de ejercicios
  late final List<String> _selectedIds;

  //Cargar los datos de la Routine ya existente
  @override
  void initState() {
    super.initState();
    final routine = widget.routine;
    _titleController = TextEditingController(text: routine.title);
    _descriptionController = TextEditingController(text: routine.description);
    _selectedIds = List<String>.from(routine.exerciseIds);
    
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

    final updatedRoutine =  widget.routine.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      exerciseIds: _selectedIds
           .where((id) => provider.exerciseById(id) != null)
           .toList()
    );
    
    //Agregar Exercise al app state
    context.read<WorkoutProvider>().updateRoutine(updatedRoutine);

    //Cerrar screen
    Navigator.pop(context);
  }

  //Elimina el Exercise del app state
  void _deleteRoutine() {
    context.read<WorkoutProvider>().deleteRoutine(widget.routine.id);
    Navigator.pop(context);
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
        title: const Text('Edit Routine'),
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
                child: GradientButton(label: 'Save Changes', onPressed: _saveChanges),
              ),

              const SizedBox(height: 12),

              //Eliminar la Routine 
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
                    'Delete Routine',
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


  //Mensaje de cofirmacion (delete)
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Routine?'),
        content: const Text('This action can not be undone'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')
          ),
          TextButton(
            onPressed: _deleteRoutine,
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