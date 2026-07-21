import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:okami/models/active_session_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:okami/models/exercise_model.dart';
import 'package:okami/models/routine_model.dart';
import 'package:okami/models/workout_session_model.dart';

class ActiveSessionProvider extends ChangeNotifier {
  ActiveSession? _session;
  static const _key = 'active_session';

  //Cargar datos con el provider
  ActiveSessionProvider() { _load(); }

//PERSISTENCIA

  //Guardar
  void _persist() {
    notifyListeners();

    _write();
  }

  Future<void> _write() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(_session!.toJson()));
  }

  //Cargar
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_key);

    if (str != null) {
      _session = ActiveSession.fromJson(jsonDecode(str) as Map<String, dynamic>);
    }

    notifyListeners();
  }

//GETTERS
  ActiveSession? get session => _session;
  bool get isActive => _session != null;
  bool get isMinimized => _session?.isMinimized ?? false;
  Duration get elapsed => _session == null ? Duration.zero
    : DateTime.now().difference(_session!.startedAt);
  int get totalExercises => _session?.exerciseIds.length ?? 0;
  int get completedExercises => _session == null ? 0
    : _session!.setsByExercise.values
        .where((sets) => sets.isNotEmpty && sets.every((s) => s.done)).length;

  double get progress =>
    totalExercises == 0 ? 0 : completedExercises / totalExercises;

//Muttators
  void _replaceExerciseSets(String exId, List<PerformedSet> newSets) {
    final newMap = Map<String, List<PerformedSet>>.from(_session!.setsByExercise);
    newMap[exId] = newSets;
    _session = _session!.copyWith(setsByExercise: newMap);
    _persist();
  }


  void _replaceSet(String exId, int i, PerformedSet newSet) {
    final sets = List<PerformedSet>.from(_session!.setsByExercise[exId]!);
    sets[i] = newSet;
    _replaceExerciseSets(exId, sets);
  }

  void addSet(String exId) {
    final sets = List<PerformedSet>.from(_session!.setsByExercise[exId]!);
    final reps = sets.isNotEmpty ? sets.last.reps : 0;
    sets.add(PerformedSet(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      reps: reps
    ));
    _replaceExerciseSets(exId, sets);
  }

  void removeSet(String exId, int i) {
    final sets = List<PerformedSet>.from(_session!.setsByExercise[exId]!);
    sets.removeAt(i);
    _replaceExerciseSets(exId, sets);
  }

  void toggleSet(String exId, int i, bool done) => _replaceSet(exId, i, _session!.setsByExercise[exId]![i].copyWith(done: done));
  void updateReps(String exId, int i, int reps) => _replaceSet(exId, i, _session!.setsByExercise[exId]![i].copyWith(reps: reps));
  void updateWeight(String exId, int i, double? weight) => _replaceSet(exId, i, _session!.setsByExercise[exId]![i].copyWith(weight: weight));

//Manejo de la sesion
  void start(Routine routine, List<Exercise> exercises) {
    _session = ActiveSession(
      routineId: routine.id,
      startedAt: DateTime.now(),
      exerciseIds: exercises.map((e) => e.id).toList(),
      setsByExercise: {
        for (final ex in exercises)
          ex.id: [
            for (var i = 0; i < ex.targetReps.length; i++)
              PerformedSet(id: '${DateTime.now().microsecondsSinceEpoch}_$i',
              reps: ex.targetReps[i]
              )
          ]
      }
    );
    _persist();
  }

  WorkOutSession finish() {
    final record = WorkOutSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      routineId: _session!.routineId, 
      date: _session!.startedAt,
      setsByExercise: _session!.setsByExercise,
      totalDurationMinutes: elapsed.inMinutes,
      completed: completedExercises == totalExercises,
    );
    _clear();
    return record;
  }

  void _clear() {
    _session = null;
    SharedPreferences.getInstance().then((p) => p.remove(_key));
    notifyListeners();
  }

  void discard() => _clear();

  void minimize() {
    _session = _session!.copyWith(isMinimized: true);
    _persist();
  }

  void expand() {
    _session = _session!.copyWith(isMinimized: false);
    _persist();
  }
}