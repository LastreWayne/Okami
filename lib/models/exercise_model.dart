enum ExerciseCategory { push, pull, cardio, resistance}

//Modelo de un ejercicio
class Exercise {
  final String id;
  final String title;
  final String description;
  final ExerciseCategory category;
  final bool bodyweight;
  final List<int> targetReps;
  int get targetSets => targetReps.length; //Geter derivado de target reps

  Exercise({
    required this.id,
    required this.title,
    required this.category,
    required this.targetReps,
    this.description = '',
    this.bodyweight = false
  });

  //Copywith para editar
  Exercise copyWith({
    String? title,
    String? description,
    ExerciseCategory? category,
    bool? bodyweight,
    List<int>? targetReps,
  }) {
    return Exercise(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      bodyweight: bodyweight ?? this.bodyweight,
      targetReps: targetReps ?? this.targetReps,
    );
  }

  //Persistencia
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category.name,
    'bodyweight': bodyweight,
    'targetReps': targetReps,
  };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    category: ExerciseCategory.values.byName(json['category'] as String),
    bodyweight: json['bodyweight'] as bool,
    targetReps: (json['targetReps'] as List).cast<int>(),
  );
}