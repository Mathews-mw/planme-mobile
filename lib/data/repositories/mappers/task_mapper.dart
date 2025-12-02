import 'package:planme/data/models/task.dart';
import 'package:planme/utils/weekdays_bitmask_encoder.dart';
import 'package:planme/data/database/isar/collections/task_isar.dart';
import 'package:planme/domains/recurrence/models/recurrence_end.dart';
import 'package:planme/domains/recurrence/models/recurrence_rule.dart';
import 'package:planme/domains/recurrence/models/recurrence_type.dart';

class TaskMapper {
  static Task toDomain(TaskIsar data) {
    RecurrenceRule? recurrence;

    if (data.baseDateTime != null && data.recurrence != null) {
      final recurrenceEnd = switch (data.recurrence!.end!.type) {
        RecurrenceEndType.never => RecurrenceEnd.never(),
        RecurrenceEndType.onDate => RecurrenceEnd.onDate(
          data.recurrence!.end!.endDate!,
        ),
        RecurrenceEndType.afterCount => RecurrenceEnd.afterCount(
          data.recurrence!.end!.count!,
        ),
      };

      recurrence = RecurrenceRule(
        type: data.recurrence!.type,
        start: data.baseDateTime!,
        end: recurrenceEnd,
        interval: data.recurrence!.interval,
        weekdays: decodeWeekdaysBitmask(data.recurrence!.weekdaysBitmask),
        dayOfMonth: data.recurrence!.dayOfMonth,
        weekOfMonth: data.recurrence!.weekOfMonth,
        weekdayOfMonth: data.recurrence!.weekdayOfMonth,
      );
    }

    return Task(
      id: data.uid,
      title: data.title,
      description: data.description,
      baseDateTime: data.baseDateTime,
      recurrence: recurrence,
      isStarred: data.isStarred,
      isCompleted: data.isCompleted,
      completedAt: data.completedAt,
      updatedAt: data.updatedAt,
      createdAt: data.createdAt,
    );
  }

  static TaskIsar toIsar(Task data) {
    RecurrenceRuleEmbedded? recurrenceData;

    if (data.recurrence != null) {
      final recurrenceEnd = RecurrenceEndEmbedded()
        ..type = data.recurrence!.end.type
        ..endDate = data.recurrence!.end.untilDate
        ..count = data.recurrence!.end.maxOccurrences;

      recurrenceData = RecurrenceRuleEmbedded()
        ..type = data.recurrence!.type
        ..interval = data.recurrence!.interval
        ..weekdaysBitmask = encodeWeekdaysBitmask(data.recurrence!.weekdays)
        ..dayOfMonth = data.recurrence!.dayOfMonth
        ..weekOfMonth = data.recurrence!.weekOfMonth
        ..weekdayOfMonth = data.recurrence!.weekdayOfMonth
        ..end = recurrenceEnd;
    }

    return TaskIsar()
      ..uid = data.id
      ..title = data.title
      ..description = data.description
      ..baseDateTime = data.baseDateTime
      ..recurrence = recurrenceData
      ..isStarred = data.isStarred
      ..isCompleted = data.isCompleted
      ..completedAt = data.completedAt
      ..createdAt = data.createdAt
      ..updatedAt = data.updatedAt;
  }
}
