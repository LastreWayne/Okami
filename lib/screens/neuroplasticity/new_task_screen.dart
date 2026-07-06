import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:okami/models/task_model.dart';
import 'package:okami/providers/task_provider.dart';
import '../../widgets/task_form_widgets.dart';
import '../../widgets/app_widgets.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  //Controlers, variables para saber lo que digo en los textfields
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  //Variables para las elecciones de los demas parametros de una Task
  int _durationMinutes = 30;
  TaskPriority _priority = TaskPriority.b;
  TaskCategory _category = TaskCategory.neuroplasticity;
  bool _repeatsWeekly = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  //Deshacerce de los controles cuando se sale de la pagina
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  //Guarda los datos de la task y los manda al provider
  void _saveTask() {

    if (_titleController.text.trim().isEmpty) {//Validacion del titulo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to provide a title')),
      );
      return;
    }

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dateTime: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute
      ),
      durationMinutes: _durationMinutes,
      priority: _priority,
      category: _category,
      repeatsWeekly: _repeatsWeekly,
    );


    //Centinelas para reglas sobre las Tasks

    final provider = context.read<TaskProvider>();
    if (newTask.dateTime.isBefore(DateTime.now())) {//Revisar que no se cree la task en el pasado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not possible to schedule a Task in the past!')
        ),
      );
      return;
    }

    final conflict = provider.findConflict(newTask);
    if (conflict != null) { //Revisar que no exista conflicto entre Tasks ya creadas
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task time conflicts with ${conflict.title}')
        ),
      );
      return;
    }

    //Agregar la Task al app state (lista central)
    context.read<TaskProvider>().addTask(newTask);

    //Cerrar screen
    Navigator.pop(context);
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
      ),

      // Scroll para el cuestionariocG
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //Titulo
            const FieldLabel('Task Title'),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'The TASK'),
            ),

            //Descripcion
            const SizedBox(height: 20),

            const FieldLabel('Task Description'),
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

                      const FieldLabel('Task Date'),
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
                                _selectedTime.format(context)
                              ),
                            ) 
                          )
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

                      const FieldLabel('Task Duration'),
                      DurationSelector(
                        value: _durationMinutes,
                        onChanged: (m) => setState(() => _durationMinutes = m)
                      ),
                    ],
                  ),
                )
              ],
            ),

            //Prioridad
            const SizedBox(height: 20),
            const FieldLabel('Task Priority'),
            PrioritySelector(
              value: _priority,
              onChanged: (p) => setState(() => _priority = p),
            ),

            //Categoria
            const SizedBox(height: 20),
            const FieldLabel('Task Category'),
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
            

            //Boton para guardar
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: GradientButton(label: 'Create Task', onPressed: _saveTask),
            )
          ]
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
}