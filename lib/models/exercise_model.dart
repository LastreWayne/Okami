enum ExerciseCategory { push, pull, cardio, resistance}

//Modelo de un ejercicio
class Exercise {
  final String id;
  final String title;
  final String description;
  final ExerciseCategory category;
  final bool bodyweight;
  final int targetSets;
  final int repsPerSet;

  Exercise({
    required this.id,
    required this.title,
    required this.category,
    this.targetSets = 3,
    this.repsPerSet = 10,
    this.description = '',
    this.bodyweight = false
  });

  //Copywith para editar
  Exercise copyWith({
    String? title,
    String? description,
    ExerciseCategory? category,
    bool? bodyweight,
    int? targetSets,
    int? repsPerSet
  }) {
    return Exercise(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      bodyweight: bodyweight ?? this.bodyweight,
      targetSets: targetSets ?? this.targetSets,
      repsPerSet: repsPerSet ?? this.repsPerSet
    );
  }

  //Persistencia
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category.name,
    'bodyweight': bodyweight,
    'targetSets': targetSets,
    'repsPerSet': repsPerSet
  };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    category: ExerciseCategory.values.byName(json['category'] as String),
    bodyweight: json['bodyweight'] as bool,
    targetSets: json['targetSets'] as int,
    repsPerSet: json['repsPerSet'] as int
  );
}