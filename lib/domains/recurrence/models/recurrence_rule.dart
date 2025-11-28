import 'package:planme/domains/recurrence/models/recurrence_end.dart';
import 'package:planme/domains/recurrence/models/recurrence_type.dart';

class RecurrenceRule {
  /// Tipo da recorrência.
  final RecurrenceType type;

  /// Data/hora a partir da qual a recorrência passa a valer.
  final DateTime start;

  /// Regras de término (nunca, até data X, depois de N vezes).
  final RecurrenceEnd end;

  /// Intervalo:
  /// - intervalDays: quantidade de dias
  /// - yearly: quantidade de anos
  final int? interval;

  /// Dias da semana permitidos (1 = Monday, ..., 7 = Sunday).
  /// Usado em [RecurrenceType.weekly].
  final Set<int>? weekdays;

  /// Dia do mês (1..31) em [RecurrenceType.monthlyDayOfMonth].
  final int? dayOfMonth;

  /// Semana do mês:
  /// - 1..4 = primeira, segunda, terceira, quarta
  /// - -1 = última semana
  /// Usado em [RecurrenceType.monthlyWeekdayOfMonth].
  final int? weekOfMonth;

  /// Dia da semana dentro do mês (1 = Monday, ..., 7 = Sunday).
  /// Usado em [RecurrenceType.monthlyWeekdayOfMonth].
  final int? weekdayOfMonth;

  const RecurrenceRule({
    required this.type,
    required this.start,
    this.end = const RecurrenceEnd.never(),
    this.interval,
    this.weekdays,
    this.dayOfMonth,
    this.weekOfMonth,
    this.weekdayOfMonth,
  });

  RecurrenceRule copyWith({
    RecurrenceType? type,
    DateTime? start,
    RecurrenceEnd? end,
    int? interval,
    Set<int>? weekdays,
    int? dayOfMonth,
    int? weekOfMonth,
    int? weekdayOfMonth,
  }) {
    return RecurrenceRule(
      type: type ?? this.type,
      start: start ?? this.start,
      end: end ?? this.end,
      interval: interval ?? this.interval,
      weekdays: weekdays ?? this.weekdays,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      weekOfMonth: weekOfMonth ?? this.weekOfMonth,
      weekdayOfMonth: weekdayOfMonth ?? this.weekdayOfMonth,
    );
  }
}
