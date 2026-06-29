import 'package:flutter_test/flutter_test.dart';
import 'package:okami/models/task_model.dart';

Task _task({required DateTime dateTime, bool repeatsWeekly = true, TaskStatus status = TaskStatus.completed}) =>
    Task(
      id: '1',
      title: 'Sunday review',
      dateTime: dateTime,
      durationMinutes: 60,
      priority: TaskPriority.a,
      category: TaskCategory.neuroplasticity,
      repeatsWeekly: repeatsWeekly,
      status: status,
      completedAt: DateTime(2026, 6, 21, 18, 30),
    );

void main() {
  group('rollToCurrentWeek', () {
    test('rolls a past Sunday task into the current week (regression)', () {
      final now = DateTime(2026, 7, 1, 10, 0);           // Wed of week Jun29–Jul5
      final task = _task(dateTime: DateTime(2026, 6, 21, 18, 0)); // a past Sunday

      final rolled = task.rollToCurrentWeek(now);

      expect(rolled.dateTime, DateTime(2026, 7, 5, 18, 0)); // this week's Sunday, time kept
      expect(rolled.status, TaskStatus.pending);            // re-armed
      expect(rolled.completedAt, isNull);                   // reset
    });
  });
}