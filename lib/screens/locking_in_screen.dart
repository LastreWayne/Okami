import 'package:flutter/material.dart';
import 'lock_in_screen.dart';

class LockingInScreen extends StatelessWidget {
  const LockingInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locking In'),
      ),

      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),

            Text(
              'Entering the following Task: ',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            //Tarjeta con la info de la Task
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    //Titulo de la task y descripcion
                    Text(
                      'Titulo por ahora ejemplo',//Ejemplo
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 24),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      'Descripcion ejemplo',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    //Datos rapidos (duracion/prioridad)
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfoChip(context, Icons.timer_outlined, '30min'),
                        _buildInfoChip(context, Icons.flag_outlined, '[A] Priority (High)'), //txto dejemplo 
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            //Confirmacion
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LockInScreen(), 
                    )
                  );
                },
                icon: const Icon(Icons.lock_outline),
                label: const Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 14),
                  child: Text('Start session'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Widget de apoyo para mostrar los datos de duracion y prioridad
  Widget _buildInfoChip(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 13))
      ],
    );
  }

}