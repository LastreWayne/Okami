
enum TaskCategory { body, neuroplasticity, motion }
enum TaskPriority { a, b, c }
enum TaskStatus { pending, completed, finishedEarly }

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final int durationMinutes;
  final TaskPriority priority;
  final TaskCategory category;
  final bool repeatsWeekly;
  final TaskStatus status;
  final DateTime? completedAt;

  Task({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.durationMinutes,
    required this.priority,
    required this.category,
    this.description = '',
    this.repeatsWeekly = false,
    this.status = TaskStatus.pending,
    this.completedAt

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
    TaskStatus? status,
    DateTime? completedAt

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
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt
    );
  }

  //Getter para el bloqueo despues de completar una task
  bool get isLocked => status != TaskStatus.pending;

  //Para el manejo de persistencia. Convertir Task a un mapa JSON-friendly
  //Los datos que requieren esto son DateTime y enums (priority/category)
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'dateTime': dateTime.toIso8601String(), //DateTime Se pasa a string
    'durationMinutes': durationMinutes,
    'priority': priority.name, //enum Se pasa a string
    'category': category.name, //enum Se pasa a string
    'repeatsWeekly': repeatsWeekly,
    'status': status.name, //Se pasa a string
    'completedAt': completedAt?.toIso8601String(),//DateTime Se pasa a string
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
    status: TaskStatus.values.byName(json['status'] as String), //String a enum
    completedAt: json['completedAt'] != null
           ? DateTime.parse(json['completedAt'] as String) //String a DateTime
           : null
  );
}



//Tweak para la visualizacion en pantalla de la prioridad
extension TaskPriorityLabel on TaskPriority {
  String get label => name.toUpperCase();
}

//Tweak para el formato de la visualizacion en pantalla del tiempo'
extension DurationLabel on int {
  String get asDuration {
    final h = this ~/ 60;
    final m = this % 60;

    if (h == 0) {
      return '$m min';
    } else {
      return '$h h $m min';
    }
  }
}