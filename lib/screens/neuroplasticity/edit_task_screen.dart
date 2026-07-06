import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:okami/models/task_model.dart';
import 'package:okami/providers/task_provider.dart';
import '../../widgets/task_form_widgets.dart';
import '../../widgets/app_widgets.dart';

class EditTaskScreen extends StatefulWidget {
  //La task que se va a editar
  final Task task;
  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  //Controlers, variables para saber lo que digo en los textfields
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  //Variables para las elecciones de los demas parametros de una Task
  late int _durationMinutes;
  late TaskPriority _priority;
  late TaskCategory _category;
  late bool _repeatsWeekly;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  //Pre-cargar los valores de la task existente
  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task.title);
    _descriptionController = TextEditingController(text: task.description);
    _durationMinutes = task.durationMinutes;
    _priority = task.priority;
    _category = task.category;
    _repeatsWeekly = task.repeatsWeekly;
    _selectedDate = task.dateTime;
    _selectedTime = TimeOfDay.fromDateTime(task.dateTime);
  }

  //Deshacerce de los controles cuando se sale de la pagina
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  //Guarda los cambios de la task y los manda al provider
  void _saveChanges() {
    if (_titleController.text.trim().isEmpty) {//Validacion del titulo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to provide a title')),
      );
      return;
    }

    //copywith conserva el id original y reemplaza lo editado
    final updatedTask = widget.task.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dateTime: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ),
      durationMinutes: _durationMinutes,
      priority: _priority,
      category: _category,
      repeatsWeekly: _repeatsWeekly,
    );

    //Centinelas para las reglas de tasks
    final provider = context.read<TaskProvider>();
    
    final conflict = provider.findConflict(updatedTask, ignoreId: widget.task.id);
    if (conflict != null) { //Revisar que no exista conflicto entre Tasks ya creadas
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task time conflicts with ${conflict.title}')
        ),
      );
      return;
    }

    //Actualizar la Task en el app state (lista central)
    context.read<TaskProvider>().updateTask(updatedTask);

    //Cerrar screen
    Navigator.pop(context);
  }

  //Elimina la task del app state
  void _deleteTask() {
    context.read<TaskProvider>().deleteTask(widget.task.id);
    Navigator.pop(context); //Cierra el dialog
    Navigator.pop(context); //Cierra la screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),

      // Scroll para el cuestionario
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //Titulo
            const FieldLabel('Title'),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'The TASK'),
            ),

            //Descripcion
            const SizedBox(height: 20),
            const FieldLabel('Description'),
            TextField(
              controller: _descriptionController,
              maxLines: 1,
              decoration: const InputDecoration(hintText: 'What is it about?'),
            ),

            //Fecha/hora y tiempo
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const FieldLabel('Date / Time'),
                      Row(
                        children: [

                          //Fecha
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _pickDate,
                              icon: const Icon(Icons.calendar_today, size: 18),
                              label: Text(
                                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          //Hora
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _pickTime,
                              icon: const Icon(Icons.access_time, size: 18),
                              label: Text(
                                _selectedTime.format(context),
                              ),
                            ),
                          ),
                        ],
                      )

                    ],
                  ),
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const FieldLabel('Duration'),
                      DurationSelector(
                        value: _durationMinutes,
                        onChanged: (m) => setState(() => _durationMinutes = m)
                      )

                    ],
                  ),
                )
              ],
            ),

            //Prioridad
            const SizedBox(height: 20),
            const FieldLabel('Priority'),
            PrioritySelector(
              value: _priority,
              onChanged: (p) => setState(() => _priority = p),
            ),

            //Categoria
            const SizedBox(height: 20),
            const FieldLabel('Category'),
            CategorySelector(
              value: _category,
              onChanged: (c) => setState(() => _category = c),
            ),

            //Repeticion
            const SizedBox(height: 20),
            const FieldLabel('Repeats weekly?'),
            RepeatToggle(
              value: _repeatsWeekly,
              onChanged: (r) => setState(() => _repeatsWeekly = r),
              trueMsg: 'Every week',
              falseMsg: 'Does not repeat',
            ),

            //Boton para guardar cambios
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: GradientButton(label: 'Save changes', onPressed: _saveChanges),
            ),

            //Boton para eliminar
            const SizedBox(height: 12),
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
                  'Delete Task',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Selector de fechas nativo de flutter
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  //Selector de hora nativo de flutter
  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  //Funcion para el mensaje de confirmacion (delete)
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task?'),
        content: const Text('This action can not be undone'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')
          ),
          TextButton(
            onPressed: _deleteTask,
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
