import 'package:flutter/material.dart';
import 'package:okami/screens/body/diet_screen.dart';
import 'package:okami/screens/body/intake_screen.dart';
import 'package:okami/screens/body/work_out_screen.dart';
import 'package:okami/widgets/app_widgets.dart';

class BodyScreen extends StatelessWidget {
  const BodyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //Titulo
              const SectionTitle(title: 'Body'),

              const SizedBox(height: 24),

              //Cards para navegar a las subscreens,

              NavCard(//Card de Workout
                label: 'Work Out',
                sublabel: 'Bring your physique to your limits',
                backgroundImg: 'assets/images/c_gym.jpg',
                onTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (_) => const WorkOutScreen())
                )
              ),

              const SizedBox(height: 20),

              NavCard(//Card de Dieta
                label: 'Diet',
                sublabel: 'Hawkeye your nutrition',
                backgroundImg: 'assets/images/food.jpg',
                onTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (_) => const DietScreen())
                )
              ),

              const SizedBox(height: 20),

              NavCard(//Card de suplementos/meds
                label: 'Intake',
                sublabel: 'Maximize your health',
                backgroundImg: 'assets/images/suplements.jpg',
                onTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (_) => const IntakeScreen())
                )
              ),
          
            ],
          ),
        )
      )
    );
  }
}