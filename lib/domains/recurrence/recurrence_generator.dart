import 'package:planme/domains/recurrence/models/recurrence_rule.dart';
import 'package:planme/domains/recurrence/models/recurrence_type.dart';

/// Gera uma lista de datas de ocorrência para uma regra de recorrência.
///
/// [from] = a partir de quando você quer começar a gerar.
/// [maxOccurrences] = limite de quantidade (além do limite da própria regra).
/// [until] = data limite (além da data de fim da própria regra).
List<DateTime> generateOccurrences({
  required RecurrenceRule rule,
  required DateTime from,
  int? maxOccurrences,
  DateTime? until,
}) {
  if (rule.type == RecurrenceType.none) {
    return const [];
  }

  final List<DateTime> result = [];

  // Data mínima a considerar (não gerar antes do start).
  final DateTime minDate = from.isBefore(rule.start) ? rule.start : from;

  DateTime? current = _firstOccurrenceOnOrAfter(rule: rule, onOrAfter: minDate);

  while (current != null) {
    // Checa término da regra.
    if (_isAfterEnd(current, rule)) break;

    // Checa limite externo até (if provided).
    if (until != null && current.isAfter(until)) break;

    result.add(current);

    // Limites de contagem: regra + parâmetro externo.
    final int count = result.length;

    if (rule.end.type == RecurrenceEndType.afterCount &&
        rule.end.maxOccurrences != null &&
        count >= rule.end.maxOccurrences!) {
      break;
    }

    if (maxOccurrences != null && count >= maxOccurrences) {
      break;
    }

    current = _nextOccurrence(rule, current);
  }

  return result;
}

/// Retorna a primeira ocorrência >= [onOrAfter], respeitando o [rule.start].
DateTime? _firstOccurrenceOnOrAfter({
  required RecurrenceRule rule,
  required DateTime onOrAfter,
}) {
  switch (rule.type) {
    case RecurrenceType.intervalDays:
      return _firstIntervalDaysOnOrAfter(rule, onOrAfter);
    case RecurrenceType.weekly:
      return _nextWeeklyAfter(
        rule,
        onOrAfter.subtract(const Duration(days: 1)),
      );
    case RecurrenceType.monthlyDayOfMonth:
      return _nextMonthlyByDayAfter(
        rule,
        onOrAfter.subtract(const Duration(days: 1)),
      );
    case RecurrenceType.monthlyWeekdayOfMonth:
      return _nextMonthlyByWeekdayAfter(
        rule,
        onOrAfter.subtract(const Duration(days: 1)),
      );
    case RecurrenceType.yearly:
      return _firstYearlyOnOrAfter(rule, onOrAfter);
    case RecurrenceType.none:
      return null;
  }
}

bool _isAfterEnd(DateTime date, RecurrenceRule rule) {
  switch (rule.end.type) {
    case RecurrenceEndType.never:
      return false;
    case RecurrenceEndType.onDate:
      final until = rule.end.untilDate;
      if (until == null) return false;
      return date.isAfter(until);
    case RecurrenceEndType.afterCount:
      // Contagem é tratada no laço principal.
      return false;
  }
}

/// Calcula a próxima ocorrência depois de [last].
DateTime? _nextOccurrence(RecurrenceRule rule, DateTime last) {
  switch (rule.type) {
    case RecurrenceType.intervalDays:
      return _nextIntervalDaysAfter(rule, last);
    case RecurrenceType.weekly:
      return _nextWeeklyAfter(rule, last);
    case RecurrenceType.monthlyDayOfMonth:
      return _nextMonthlyByDayAfter(rule, last);
    case RecurrenceType.monthlyWeekdayOfMonth:
      return _nextMonthlyByWeekdayAfter(rule, last);
    case RecurrenceType.yearly:
      return _nextYearlyAfter(rule, last);
    case RecurrenceType.none:
      return null;
  }
}

int _daysInMonth(int year, int month) {
  // Truque clássico: dia 0 do próximo mês = último dia do mês atual.
  final lastDay = DateTime(year, month + 1, 0);
  return lastDay.day;
}

//
// 1) Intervalo de dias (intervalDays)
//

DateTime? _firstIntervalDaysOnOrAfter(RecurrenceRule rule, DateTime onOrAfter) {
  final int intervalDays = rule.interval ?? 1;
  if (intervalDays <= 0) return null;

  final DateTime start = rule.start;

  if (!start.isBefore(onOrAfter)) {
    return start;
  }

  final diffDays = onOrAfter.difference(start).inDays;
  final steps = diffDays ~/ intervalDays;
  DateTime candidate = start.add(Duration(days: steps * intervalDays));

  if (candidate.isBefore(onOrAfter)) {
    candidate = candidate.add(Duration(days: intervalDays));
  }

  return candidate;
}

DateTime? _nextIntervalDaysAfter(RecurrenceRule rule, DateTime last) {
  final int intervalDays = rule.interval ?? 1;
  if (intervalDays <= 0) return null;
  return last.add(Duration(days: intervalDays));
}

//
// 2) Weekly (dias específicos da semana)
//

DateTime? _nextWeeklyAfter(RecurrenceRule rule, DateTime after) {
  final weekdays = rule.weekdays;
  if (weekdays == null || weekdays.isEmpty) return null;

  final start = rule.start;
  // Começa a buscar do dia seguinte ao "after" (em dias inteiros).
  DateTime baseDate = DateTime(after.year, after.month, after.day);

  DateTime? best;

  // Loop no máximo por 14 dias pra garantir que achamos alguma combinação.
  for (int i = 0; i < 14; i++) {
    final d = baseDate.add(Duration(days: i));
    if (!weekdays.contains(d.weekday)) continue;

    final candidate = DateTime(
      d.year,
      d.month,
      d.day,
      start.hour,
      start.minute,
      start.second,
      start.millisecond,
      start.microsecond,
    );

    if (candidate.isAfter(after) && !candidate.isBefore(start)) {
      if (best == null || candidate.isBefore(best)) {
        best = candidate;
      }
    }
  }

  return best;
}

//
// 3) Monthly - dia específico do mês
//

DateTime? _nextMonthlyByDayAfter(RecurrenceRule rule, DateTime after) {
  final int? dayOfMonth = rule.dayOfMonth;
  if (dayOfMonth == null) return null;

  final start = rule.start;

  int year = after.year;
  int month = after.month;

  while (true) {
    final dim = _daysInMonth(year, month);
    final int safeDay = dayOfMonth <= dim ? dayOfMonth : dim;

    final candidate = DateTime(
      year,
      month,
      safeDay,
      start.hour,
      start.minute,
      start.second,
      start.millisecond,
      start.microsecond,
    );

    if (candidate.isAfter(after) && !candidate.isBefore(start)) {
      return candidate;
    }

    // Avança para o próximo mês
    month++;
    if (month > 12) {
      month = 1;
      year++;
    }

    // por segurança, você poderia colocar um limite de ano aqui
    // pra evitar loop infinito em caso de regra inválida.
  }
}

//
// 4) Monthly - N-ésimo dia da semana do mês (ex: 3ª quarta, última sexta)
//

DateTime _nthWeekdayOfMonth(int year, int month, int weekday, int n) {
  // n >= 1
  final firstDayOfMonth = DateTime(year, month, 1);
  final int firstWeekday = firstDayOfMonth.weekday; // 1..7
  final int diff = (weekday - firstWeekday + 7) % 7;
  final int day = 1 + diff + (n - 1) * 7;
  return DateTime(year, month, day);
}

DateTime _lastWeekdayOfMonth(int year, int month, int weekday) {
  final lastDayOfMonth = DateTime(year, month + 1, 0); // último dia do mês
  final int lastWeekday = lastDayOfMonth.weekday;
  final int diff = (lastWeekday - weekday + 7) % 7;
  final int day = lastDayOfMonth.day - diff;
  return DateTime(year, month, day);
}

DateTime? _nextMonthlyByWeekdayAfter(RecurrenceRule rule, DateTime after) {
  final int? weekOfMonth = rule.weekOfMonth;
  final int? weekdayOfMonth = rule.weekdayOfMonth;
  if (weekOfMonth == null || weekdayOfMonth == null) return null;

  final start = rule.start;

  int year = after.year;
  int month = after.month;

  while (true) {
    final DateTime candidateBase;
    if (weekOfMonth > 0) {
      candidateBase = _nthWeekdayOfMonth(
        year,
        month,
        weekdayOfMonth,
        weekOfMonth,
      );
    } else if (weekOfMonth == -1) {
      // última ocorrência do weekday no mês
      candidateBase = _lastWeekdayOfMonth(year, month, weekdayOfMonth);
    } else {
      // semana inválida
      return null;
    }

    final candidate = DateTime(
      candidateBase.year,
      candidateBase.month,
      candidateBase.day,
      start.hour,
      start.minute,
      start.second,
      start.millisecond,
      start.microsecond,
    );

    if (candidate.isAfter(after) && !candidate.isBefore(start)) {
      return candidate;
    }

    month++;
    if (month > 12) {
      month = 1;
      year++;
    }
  }
}

//
// 5) Yearly (a cada X anos)
//

DateTime? _firstYearlyOnOrAfter(RecurrenceRule rule, DateTime onOrAfter) {
  final start = rule.start;
  final int intervalYears = rule.interval ?? 1;
  if (intervalYears <= 0) return null;

  if (!start.isBefore(onOrAfter)) return start;

  int k = 0;
  if (onOrAfter.year > start.year) {
    final yearDiff = onOrAfter.year - start.year;
    k = yearDiff ~/ intervalYears;
  }

  while (true) {
    final candidate = DateTime(
      start.year + k * intervalYears,
      start.month,
      start.day,
      start.hour,
      start.minute,
      start.second,
      start.millisecond,
      start.microsecond,
    );

    if (candidate.isAfter(onOrAfter) && !candidate.isBefore(start)) {
      return candidate;
    }

    k++;
  }
}

DateTime? _nextYearlyAfter(RecurrenceRule rule, DateTime last) {
  final int intervalYears = rule.interval ?? 1;
  if (intervalYears <= 0) return null;

  return DateTime(
    last.year + intervalYears,
    last.month,
    last.day,
    last.hour,
    last.minute,
    last.second,
    last.millisecond,
    last.microsecond,
  );
}
