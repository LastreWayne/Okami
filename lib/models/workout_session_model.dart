
class PerformedSet {
  static const _sentinel = Object();
  
  final String id;
  final int reps;
  final double? weight;
  final int durationSeconds;
  final bool done;

  PerformedSet({
    required this.id,
    required this.reps,
    this.weight ,
    this.durationSeconds = 0,
    this.done = false,
  });

  PerformedSet copyWith({
    int? reps,
    Object? weight = _sentinel,
    int? durationSeconds,
    bool? done,
  }) {
    return PerformedSet(
      id: id,
      reps: reps ?? this.reps,
      weight: identical(weight, _sentinel) ? this.weight : weight as double?,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      done: done ?? this.done
    );
  }


  //Persistencia
  Map<String, dynamic> toJson() => {
    'id': id,
    'reps': reps,
    'weight': weight,
    'durationSeconds': durationSeconds,
    'done': done
  };

  factory PerformedSet.fromJson(Map<String, dynamic> json) => PerformedSet(
    id: json['id'] as String,
    reps: json['reps'] as int,
    weight: (json['weight'] as num?)?.toDouble(),
    durationSeconds: json['durationSeconds'] as int? ?? 0,
    done: json['done'] as bool
  );
}

class WorkOutSession {
  final String id;
  final String routineId;
  final DateTime date;
  final Map<String, List<PerformedSet>> setsByExercise;
  final int totalDurationMinutes;
  final bool completed;

  WorkOutSession ({
    required this.id,
    required this.routineId,
    required this.date,
    required this.setsByExercise,
    this.totalDurationMinutes = 0,
    this.completed = false,
  });

  //Persistencia
  Map<String, dynamic> toJson() => {
    'id': id,
    'routineId': routineId,
    'date': date.toIso8601String(),
    'setsByExercise': setsByExercise.map(
      (id, sets) => MapEntry(id, sets.map((s) => s.toJson()).toList())
    ),
    'totalDurationMinutes': totalDurationMinutes,
    'completed': completed
  };

  factory WorkOutSession.fromJson(Map<String, dynamic> json) => WorkOutSession(
    id: json['id'] as String,
    routineId: json['routineId'] as String,
    date: DateTime.parse(json['date'] as String),
    setsByExercise: (json['setsByExercise'] as Map<String, dynamic>).map(
      (id, value) => MapEntry(id, 
                    (value as List).map( (e) => PerformedSet.fromJson( e as Map<String, dynamic> ) ).toList()
      ),
    ),
    totalDurationMinutes: json['totalDurationMinutes'] as int,
    completed: json['completed'] as bool,
  );
}
