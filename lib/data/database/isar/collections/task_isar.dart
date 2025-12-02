import 'package:isar/isar.dart';
import 'package:planme/domains/recurrence/models/recurrence_type.dart';

part 'task_isar.g.dart';

@collection
@Name("tasks")
class TaskIsar {
  /// ID interno do Isar (chave primária)
  Id id = Isar.autoIncrement;

  /// ID estável para sync com backend
  @Index(unique: true, replace: true)
  late String uid;

  late String title;
  String? description;

  @Name("base_datetime")
  DateTime? baseDateTime;

  @Name("is_starred")
  bool isStarred = false;
  @Name("is_completed")
  bool isCompleted = false;
  @Name("completed_at")
  DateTime? completedAt;

  @Name("created_at")
  late DateTime createdAt;
  @Name("updated_at")
  DateTime? updatedAt;

  RecurrenceRuleEmbedded? recurrence;
}

@embedded
class RecurrenceRuleEmbedded {
  /// 'none', 'intervalDays', 'weekly', 'monthlyDayOfMonth',
  /// 'monthlyWeekdayOfMonth', 'yearly'
  @Enumerated(EnumType.ordinal)
  late RecurrenceType type;

  /// dias (intervalDays) / anos (yearly)
  int? interval;

  /// Weekly: bitmask de dias (1..7)
  int? weekdaysBitmask;

  /// Monthly (dia do mês)
  int? dayOfMonth;

  /// Monthly weekday-of-month: 1..4, -1 = last week
  int? weekOfMonth;

  /// 1..7 (mon..sun)
  int? weekdayOfMonth;

  RecurrenceEndEmbedded? end;
}

@embedded
class RecurrenceEndEmbedded {
  /// 'never', 'onDate', 'afterCount'
  @Enumerated(EnumType.ordinal)
  late RecurrenceEndType type;

  DateTime? endDate;
  int? count;
}
