import 'workout_session_model.dart';

class ActiveSession {
  final String routineId;
  final DateTime startedAt;
  final List<String> exerciseIds;
  final Map<String, List<PerformedSet>> setsByExercise;
  final bool isMinimized;

  ActiveSession ({
    required this.routineId,
    required this.startedAt,
    required this.exerciseIds,
    required this.setsByExercise,
    this.isMinimized = false,
  });

  ActiveSession copyWith({
    String? routineId,
    DateTime? startedAt,
    List<String>? exerciseIds,
    Map<String, List<PerformedSet>>? setsByExercise,
    bool? isMinimized,
  }) {
    return ActiveSession(
      routineId: routineId ?? this.routineId,
      startedAt: startedAt ?? this.startedAt,
      exerciseIds: exerciseIds ?? this.exerciseIds,
      setsByExercise: setsByExercise ?? this.setsByExercise,
      isMinimized: isMinimized ?? this.isMinimized,
    );
  }

  //Persistencia
  Map<String, dynamic> toJson() => {
    'routineId': routineId,
    'startedAt': startedAt.toIso8601String(),
    'exerciseIds': exerciseIds,
    'setsByExercise': setsByExercise.map(
      (id, sets) => MapEntry(id, sets.map((s) => s.toJson()).toList())
    ),
    'isMinimized': isMinimized,
  };

  factory ActiveSession.fromJson(Map<String, dynamic> json) => ActiveSession(
    routineId: json['routineId'] as String,
    startedAt: DateTime.parse(json['startedAt'] as String),
    exerciseIds: (json['exerciseIds'] as List).cast<String>(),
    setsByExercise: (json['setsByExercise'] as Map<String, dynamic>).map(
      (id, value) => MapEntry(id, 
                    (value as List).map( (e) => PerformedSet.fromJson( e as Map<String, dynamic> ) ).toList()
      ),
    ),
    isMinimized: json['isMinimized'] as bool,
  );

}