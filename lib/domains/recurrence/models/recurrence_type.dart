enum RecurrenceType {
  none,

  /// A cada X dias (interval).
  intervalDays,

  /// Em dias específicos da semana (seg, qua, sex...).
  weekly,

  /// No dia X de cada mês (ex: dia 10).
  monthlyDayOfMonth,

  /// Ex: terceira quarta-feira do mês, última sexta etc.
  monthlyWeekdayOfMonth,

  /// A cada X anos.
  yearly;

  String get value {
    switch (this) {
      case none:
        return 'none';
      case intervalDays:
        return 'intervalDays';
      case weekly:
        return 'weekly';
      case monthlyDayOfMonth:
        return 'monthlyDayOfMonth';
      case monthlyWeekdayOfMonth:
        return 'monthlyWeekdayOfMonth';
      case yearly:
        return 'yearly';
    }
  }

  String get label {
    switch (this) {
      case none:
        return 'None';
      case intervalDays:
        return 'Day interval';
      case weekly:
        return 'Weekly';
      case monthlyDayOfMonth:
        return 'Day of the month';
      case monthlyWeekdayOfMonth:
        return 'Week day of the month';
      case yearly:
        return 'Yearly';
    }
  }
}

enum RecurrenceEndType {
  never,
  onDate,
  afterCount;

  String get value {
    switch (this) {
      case never:
        return 'never';
      case onDate:
        return 'onDate';
      case afterCount:
        return 'afterCount';
    }
  }

  String get label {
    switch (this) {
      case never:
        return 'Never';
      case onDate:
        return 'On date';
      case afterCount:
        return 'After interval';
    }
  }
}
