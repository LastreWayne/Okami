import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  //Lista central debe ser privada
  //Aqui se van a almacenar la informacion de las tasks
  final List<Task> _tasks = [];
  static const _storageKey = 'tasks'; //Llave que representa la lista de tasks en JSON

  //Cargar los datos con el provider
  TaskProvider() {
    _load();
  }

  //getter publico para solo lectura.
  List <Task> get tasks => List.unmodifiable(_tasks);


//PERSISTENCIA DE LAS TASKS

  // GUARDAR TASK: Convierte a JSON y lo escribe en el disco
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(
      _tasks.map((task) => task.toJson()).toList(), //Pasamos la lista de tasks al mapa de json a string
    );
    await prefs.setString(_storageKey, jsonString);
  }

  // CARGAR TASK: lee el disco y reconstruye las taks para su uso dentro del app
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return;

    final List<dynamic> decoded = jsonDecode(jsonString);
    _tasks
      ..clear()
      ..addAll(decoded.map((item) => Task.fromJson(item as Map<String, dynamic>)));
    notifyListeners();//Le dice al sistema que se actualizaron los datos
  }


//MANIPULACION DE TASKS

  //Agregar una task
  void addTask(Task task) {
    _tasks.add(task);
    _save(); //Guarda el cambio para la persistencia
    notifyListeners();
  }

  //Editar una task
  void updateTask(Task updatedTask) {
    final idx = _tasks.indexWhere((t) => t.id == updatedTask.id); //Encontrar el id de la task que interesa

    if (idx != -1) {//si la encuentra la modifica
      _tasks[idx] = updatedTask;
      _save();
      notifyListeners();
    }
  }
  
  //Eliminar una task
  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    _save();
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

  //Reconocer la task actual dentro de la ventana de tiempo de duracion de la task
  Task? currentTask() {
    final now = DateTime.now();

    for (final task in _tasks) {
      if (task.isLocked) continue;//Condicional para ignorar tasks que ya han sido completadas

      final windowStart = task.dateTime.subtract(const Duration(minutes: 15));
      final windowEnd = task.dateTime.add(Duration(minutes: task.durationMinutes));

      if (now.isAfter(windowStart) && now.isBefore(windowEnd)) {
        return task;
      }
    }
    return null;
  }

  //Reconoce si hay algun task en conflicto de hora con otra
  Task? findConflict(Task candidate, {String? ignoreId}) {
    final candidateStart = candidate.dateTime;
    final candidateEnd = candidate.dateTime.add(Duration(minutes: candidate.durationMinutes));

    for (final task in _tasks) {//Revisa las tasks existentes y confirma si hay conflictos
      if (task.id == ignoreId) continue; //Evita que la task se choque con ella misma
      if (task.isLocked) continue; //Ignorar la task si ya fue completada

      final start = task.dateTime;
      final end = task.dateTime.add(Duration(minutes: task.durationMinutes));

      //Dos tasks se interrumpen si newStart < end y start < newEnd
      final overlaps = candidateStart.isBefore(end) && start.isBefore(candidateEnd);
      if (overlaps) return task;
    }
    return null;
  }

}