import 'package:flutter/material.dart';
import 'package:okami/models/routine_model.dart';
import 'package:okami/providers/workout_provider.dart';
import 'package:okami/screens/body/starting_routine_screen.dart';
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

              //List view cards de rutinas (situacional)
              Expanded(
                child: routines.isEmpty
                    ? BuildEmptyState(msg: 'You dont have any Routines!')
                    : _buildRoutineList(context, routines)
              ),
              

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

  Widget _buildRoutineList(BuildContext context, List<Routine> routines) {
    return ListView.builder(
      itemCount: routines.length,
      itemBuilder: (context, idx) {
        final routine = routines[idx];
        return RoutineCard(
          routine: routine,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditRoutineScreen(routine: routine))
            );
          },
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StartingRoutineScreen())
            );
          }
        );
      }
    );
  }
}