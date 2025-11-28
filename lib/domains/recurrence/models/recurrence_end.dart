import 'package:planme/domains/recurrence/models/recurrence_type.dart';

class RecurrenceEnd {
  final RecurrenceEndType type;
  final DateTime? untilDate;
  final int? maxOccurrences;

  const RecurrenceEnd._({
    required this.type,
    this.untilDate,
    this.maxOccurrences,
  });

  const RecurrenceEnd.never() : this._(type: RecurrenceEndType.never);

  const RecurrenceEnd.onDate(DateTime until)
    : this._(type: RecurrenceEndType.onDate, untilDate: until);

  const RecurrenceEnd.afterCount(int count)
    : this._(type: RecurrenceEndType.afterCount, maxOccurrences: count);
}
