import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  //Lista central debe ser privada
  //Aqui se van a almacenar la informacion de las tasks
  final List<Task> _tasks = [];

  //getter publico para solo lectura.
  List <Task> get tasks => List.unmodifiable(_tasks);

  //Agregar una task
  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  //Editar una task
  void updateTask(Task updatedTask) {
    final idx = _tasks.indexWhere((t) => t.id == updatedTask.id); //Encontrar el id de la task que interesa

    if (idx != -1) {//si la encuentra la modifica
      _tasks[idx] = updatedTask;
      notifyListeners();
    }
  }
  
  //Eliminar una task
  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  //Filtrar las tasks por dia (para su visualizacion)
  List<Task> tasksByDay(DateTime day) {
    return _tasks.where((task) {
      return task.dateTime.year == day.year &&
             task.dateTime.month == day.month &&
             task.dateTime.day == day.day;
      
    }).toList();
  }
}