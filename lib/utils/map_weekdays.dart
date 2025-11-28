enum DayFormat {
  abbreviated, // 'M', 'T', ...
  short, // 'Mon', 'Tue', ...
  full, // 'Monday', 'Tuesday', ...
}

List<String> mapWeekDays(
  List<int> days, [
  DayFormat format = DayFormat.abbreviated,
]) {
  return days.map((day) {
    if (day < 1 || day > 7) {
      throw ArgumentError('Invalid day: $day');
    }

    return _getNameForDay(day, format);
  }).toList();
}

String _getNameForDay(int day, DayFormat format) {
  return switch (day) {
    1 => _formatVariant(format, 'M', 'Mon', 'Monday'),
    2 => _formatVariant(format, 'T', 'Tue', 'Tuesday'),
    3 => _formatVariant(format, 'W', 'Wed', 'Wednesday'),
    4 => _formatVariant(format, 'T', 'Thu', 'Thursday'),
    5 => _formatVariant(format, 'F', 'Fri', 'Friday'),
    6 => _formatVariant(format, 'S', 'Sat', 'Saturday'),
    7 => _formatVariant(format, 'S', 'Sun', 'Sunday'),
    _ => 'Unknown', // Caso inalcançável devido à validação anterior
  };
}

String _formatVariant(
  DayFormat format,
  String abbr,
  String short,
  String full,
) {
  return switch (format) {
    DayFormat.abbreviated => abbr,
    DayFormat.short => short,
    DayFormat.full => full,
  };
}
