import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:okami/models/exercise_model.dart';
import 'package:okami/models/routine_model.dart';
import 'package:okami/models/workout_session_model.dart';

class WorkoutProvider extends ChangeNotifier {

  //Listas centrales donde viven los datos de Workout
  final List<Exercise> _exercises = [];
  static const _exercisesStorageKey = 'exercises';

  final List<Routine> _routines = [];
  static const _routinesStorageKey = 'routines';

  final List<WorkOutSession> _workoutSessions = [];
  static const _workoutSessionStorageKey = 'workout_sessions';

  //Cargar los datos con el provider
  WorkoutProvider() {
    _load();
  }

//PERSISTENCIA
  
  //Save general para los tres modelos
  Future<void> _save(String key, List<dynamic> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(
      items.map((item) => item.toJson()).toList())
    );
  }

  //Load
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    
    final exString = prefs.getString(_exercisesStorageKey);
    if (exString != null) {
      final List<dynamic> exDecoded = jsonDecode(exString);
      _exercises
        ..clear()
        ..addAll(exDecoded.map( (item) => Exercise.fromJson(item as Map<String, dynamic>)));
    }

    final roString = prefs.getString(_routinesStorageKey);
    if (roString != null) {
      final List<dynamic> roDecoded = jsonDecode(roString);
      _routines
        ..clear()
        ..addAll(roDecoded.map( (item) => Routine.fromJson(item as Map<String, dynamic>)));
    }

    final wsString = prefs.getString(_workoutSessionStorageKey);
    if (wsString != null) {
      final List<dynamic> decoded = jsonDecode(wsString);
      _workoutSessions
        ..clear()
        ..addAll(decoded.map( (item) => WorkOutSession.fromJson(item as Map<String, dynamic>)));
    }
    
    notifyListeners();
  }

//MANIPULACION DE LOS MODELOS 

//EJERCICIOS

  //Agregar un ejercicio
  void addExercise(Exercise exercise) {
    _exercises.add(exercise);
    _save(_exercisesStorageKey, _exercises);
    notifyListeners();
  }

  //Editar un ejercicio
  void updateExercise (Exercise updatedExercise) {
    final idx = _exercises.indexWhere((i) => i.id == updatedExercise.id);

    if (idx != -1) {
      _exercises[idx] = updatedExercise;
      _save(_exercisesStorageKey, _exercises);
      notifyListeners();
    }
  }

  //Eliminar un ejercicio
  void deleteExercise(String id) {
    _exercises.removeWhere((i) => i.id == id);
    _save(_exercisesStorageKey, _exercises);
    notifyListeners();
  }

  //Encontrar un ejercicio dado su ID
  Exercise? exerciseById(String id) {
    for (final e in _exercises) {
      if (e.id == id) return e;
    }
    return null;
  }

//RUTINAS

  //Agregar una rutina
  void addRoutine(Routine routine) {
    _routines.add(routine);
    _save(_routinesStorageKey, _routines);
    notifyListeners();
  }

  //Editar una rutina
  void updateRoutine (Routine updatedRoutine) {
    final idx = _routines.indexWhere((i) => i.id == updatedRoutine.id);

    if (idx != -1) {
      _routines[idx] = updatedRoutine;
      _save(_routinesStorageKey, _routines);
      notifyListeners();
    }
  }

  //Eliminar una rutina
  void deleteRoutine(String id) {
    _routines.removeWhere((i) => i.id == id);
    _save(_routinesStorageKey, _routines);
    notifyListeners();
  }

//SESION

  //Agregar una sesion
  void addWorkoutSession(WorkOutSession workoutSession) {
    _workoutSessions.add(workoutSession);
    _save(_workoutSessionStorageKey, _workoutSessions);
    notifyListeners();
  }



}