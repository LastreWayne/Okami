
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
  Task copywith({
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
}