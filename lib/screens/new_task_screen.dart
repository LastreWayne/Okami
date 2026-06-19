import 'package:flutter/material.dart';
import '../widgets/task_form_widgets.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
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
            FieldLabel('Descripcion'),
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
                      FieldLabel('Date/Hour'),
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
            

            //Boton para guardar
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
                  child: Text('Create Task'),
                ),
              ),
            )
          ]
        ),
      ),
    );
  }
}