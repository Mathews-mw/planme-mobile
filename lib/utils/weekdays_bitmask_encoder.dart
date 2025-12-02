/// Codificar Set<int> → int
int encodeWeekdaysBitmask(Set<int>? weekdays) {
  if (weekdays == null || weekdays.isEmpty) return 0;

  var mask = 0;
  for (final w in weekdays) {
    // w esperado entre 1 e 7 (DateTime.monday..sunday)
    final index = w - 1;
    if (index < 0 || index > 6) continue;
    mask |= (1 << index);
  }
  return mask;
}

/// Decodificar int → Set<int>
Set<int>? decodeWeekdaysBitmask(int? bitmask) {
  if (bitmask == null || bitmask == 0) return {};

  final result = <int>{};
  for (var i = 0; i < 7; i++) {
    final hasBit = (bitmask & (1 << i)) != 0;
    if (hasBit) {
      result.add(i + 1); // volta pra 1..7 (DateTime.monday..sunday)
    }
  }
  return result;
}
