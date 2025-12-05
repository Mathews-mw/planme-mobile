enum AgendaRangeFilter {
  next7Days,
  next15Days,
  next30Days,
  next45Days,
  next60Days,
  custom,
}

extension AgendaRangeFilterExt on AgendaRangeFilter {
  String get label {
    switch (this) {
      case AgendaRangeFilter.next7Days:
        return '7 days';
      case AgendaRangeFilter.next15Days:
        return '15 days';
      case AgendaRangeFilter.next30Days:
        return '30 days';
      case AgendaRangeFilter.next45Days:
        return '45 days';
      case AgendaRangeFilter.next60Days:
        return '60 days';
      case AgendaRangeFilter.custom:
        return 'Custom';
    }
  }

  int? get days {
    switch (this) {
      case AgendaRangeFilter.next7Days:
        return 7;
      case AgendaRangeFilter.next15Days:
        return 15;
      case AgendaRangeFilter.next30Days:
        return 30;
      case AgendaRangeFilter.next45Days:
        return 45;
      case AgendaRangeFilter.next60Days:
        return 60;
      case AgendaRangeFilter.custom:
        return null; // custom não tem days fixo
    }
  }
}
