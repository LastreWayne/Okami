
enum TaskCategory { body, neuroplasticity, motion }
enum TaskPriority { a, b, c }

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final int durationMinutes;
  final TaskPriority priority;
  final TaskCategory category;
  final bool repeatsWeekly;

  Task({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.durationMinutes,
    required this.priority,
    required this.category,
    this.description = '',
    this.repeatsWeekly = false,

  });

  //Metodo copywith para editar las task
  Task copyWith({
    String? title,
    String? description,
    DateTime? dateTime,
    int? durationMinutes,
    TaskPriority? priority,
    TaskCategory? category,
    bool? repeatsWeekly,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      priority: priority ??  this.priority,
      category: category ?? this.category,
      repeatsWeekly: repeatsWeekly ?? this.repeatsWeekly,
    );
  }

  //Para el manejo de persistencia. Convertir Task a un mapa JSON-friendly
  //Los datos que requieren esto son DateTime y enums (priority/category)
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'dateTime': dateTime.toIso8601String(), //Se pasa a string
    'durationMinutes': durationMinutes,
    'priority': priority.name, //Se pasa a string
    'category': category.name, //Se pasa a string
    'repeatsWeekly': repeatsWeekly,
  };

  //Ahora reconstruye desde JSON a la Task
  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    dateTime: DateTime.parse(json['dateTime'] as String), //De string de vuelta a DateTime
    durationMinutes: json['durationMinutes'] as int,
    priority: TaskPriority.values.byName(json['priority'] as String), //String a enum
    category: TaskCategory.values.byName(json['category'] as String), //String a enum
    repeatsWeekly: json['repeatsWeekly'] as bool,
  );
}



//Tweak para la visualizacion en pantalla de la prioridad
extension TaskPriorityLabel on TaskPriority {
  String get label => name.toUpperCase();
}