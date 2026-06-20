import 'package:flutter/material.dart';
import '../../widgets/task_form_widgets.dart';

class EditTaskScreen extends StatelessWidget {
  const EditTaskScreen({super.key});

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
            FieldLabel('Title'),
            const TextField(
              decoration: InputDecoration(
                hintText: 'The TASK',
                border: OutlineInputBorder()
              ),
            ),

            //Descripcion
            const SizedBox(height: 20),
            FieldLabel('Description'),
            const TextField(
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'What is it about?',
                border: OutlineInputBorder(), 
              ),
            ),

            //Fecha/hora y tiempo
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldLabel('Time/Hour'),
                      const TextField(
                        decoration: InputDecoration(
                          hintText: '00:00',
                          border:  OutlineInputBorder(),
                        )
                      )
                    ],
                  ),
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldLabel('Duration'),
                      const TextField(
                        decoration: InputDecoration(
                          hintText: 'How much?',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),

            //Prioridad
            const SizedBox(height: 20),
            FieldLabel('Priority'),
            const Center(child: PrioritySelector()),

            //Categoria
            const SizedBox(height: 20),
            FieldLabel('Category'),
            const Center(child: CategorySelector()),

            //Repeticion
            const SizedBox(height: 20),
            const RepeatToggle(),
            

            //Boton para guardar cambios
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  //Por implementar funcionalidad

                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('Save changes'),
                ),
              ),
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
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
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