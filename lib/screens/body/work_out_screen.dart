import 'package:flutter/material.dart';
import 'package:okami/providers/workout_provider.dart';
import 'package:okami/widgets/workout_widgets.dart';
import 'package:okami/widgets/app_widgets.dart';
import 'new_routine_screen.dart';
import 'edit_routine_screen.dart';
import 'package:provider/provider.dart';

class WorkOutScreen extends StatelessWidget {
  const WorkOutScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final routines = context.watch<WorkoutProvider>().routines;


    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Titulo
              const SectionTitle(title: 'WorkOut Routines', subtitle: 'What are you training today?'),

              const SizedBox(height: 20),

              //List view cards de rutinas
              

              //Boton para crear una nueva rutina
              GradientButton(
                label: 'New Routine',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewRoutineScreen())
                  );
                }
              )
            ],
          ),
        ) 
      )
    );
  }
}