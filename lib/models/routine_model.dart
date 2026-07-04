
//Modelo de una rutina
class Routine {
  final String id;
  final String title;
  final String description;
  final List<String> exerciseIds;

  Routine({
    required this.id,
    required this.title,
    required this.exerciseIds,
    this.description = ''
  });

  //Copywith para editar una rutina
  Routine copyWith({
    String? title,
    String? description,
    List<String>? exerciseIds,
  }) {
    return Routine(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      exerciseIds: exerciseIds ?? this.exerciseIds,
    );
  }

  //Persistencia

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'exerciseIds': exerciseIds,
  };

  factory Routine.fromJson(Map<String, dynamic> json) => Routine(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    exerciseIds: (json['exerciseIds'] as List).cast<String>()
  );

}