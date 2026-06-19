import 'dart:async'; //import para el timer
import 'package:flutter/material.dart';

class LockInScreen extends StatefulWidget {
  const LockInScreen({super.key});

  @override  
  State<LockInScreen> createState() => _LockInScreenState();
}

class _LockInScreenState extends State<LockInScreen> {

  //Duracion total de la sesion
  static const int _totalSeconds = 1800; //Por ahora esta fixed este dato (30min)

  //Segundos que quedan
  int _remainingSeconds = _totalSeconds; //Claramente empieza por el total de segundos

  //Herramienta de timer
  Timer? _timer;

  //Sesion pausada o corriendo?
  bool _isPaused = false; //empieza corriendo entonces no esta parada por default

  //Manejo del estado de la clase
  @override  
  void initState() {
    super.initState();
    _startTimer();
  }

  //Inicializa (o continua) el timer
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          //llego a cero se detiene
          _timer?.cancel();
        }
      });
    });
  }

  //Pausa o continua segun el estado
  void _togglePause() {
    setState(() {
      if (_isPaused) {//si esta pausado lo continua
        _startTimer();
        _isPaused = false;
      } else {//si no pues lo pausa
        _timer?.cancel();
        _isPaused = true;
      }
    });
  }

  //Estado de la sesion para mostrarlo en pantalla
  String get _sessionState {
    if (_remainingSeconds == 0 ) return 'Finished!';
    if (_isPaused) return 'In Pause...';

    //Ahora el 'Almost there' (90% de la sesion completada)
    if (_remainingSeconds <= _totalSeconds * 0.1) return 'Almots there!'; //si los segundos que quedan son menores al 10%

    return 'Active *';   
  }

  //Convierte segundos al formato indicado para mostrar en pantalla
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60; //division entera
    final secs = seconds % 60; //mod

    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}'; //formateo MM:SS
  }

  //Cancelo el timer al salir
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  //Construyo widget del timer
  @override
  Widget build(BuildContext context) {
    final bool isFinished = _remainingSeconds == 0;

    final double progress = (_totalSeconds - _remainingSeconds) / _totalSeconds;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [

              //Titulo de la sesion
              const SizedBox(height: 20),
              Text(
                'Titulo de ejemplo',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 24),
              ),

              //Estado de la sesion
              Text(
                _sessionState,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const Spacer(),

              //Circulo con el timer
              SizedBox(
                width: 240,
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    //Circulo de progreso de fondo
                    SizedBox(
                      width: 240,
                      height: 240,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,

                        //Cuando termina se convierte al color primario
                        color: isFinished? Theme.of(context).colorScheme.primary:Theme.of(context).colorScheme.secondary,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                      ),
                    ),

                    //El tiempo
                    Text(
                      _formatTime(_remainingSeconds),
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              //Botones de control
              Row(
                children: [
                  
                  //Boton de pausa/continuar
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isFinished ? null : _togglePause,
                      icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(_isPaused ? 'Continue' : 'Pause'),
                      ),
                    ),
                  ),

                  //Finalizar Task
                  const SizedBox(width: 12),

                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _handeFinish(isFinished),
                      icon: const Icon(Icons.check),
                      label: const Padding(
                        padding: EdgeInsetsGeometry.symmetric(vertical: 14),
                        child: Text('Finish'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Pequeña logica del boton para finalizar 
  void _handeFinish(bool isFinished) {
    if (isFinished) { //El timer ya termino, se dirige a el summary screen
      _goToSummary();
    } else {//No se ha terminado el tiempo de la Task, mensajes de retencion
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('There is still time left. Finish your Task'),
        actions: [

          //Boton para seguri la task
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Resume the Task')
          ),

          //Boton para salir definitivamente de la task
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _goToSummary();
            }, 
            child: const Text('Take the easy way out'),
            ),
          ],
        ),
      );
    }
  }

  void _goToSummary() {
    Navigator.pop(context);
  }


}