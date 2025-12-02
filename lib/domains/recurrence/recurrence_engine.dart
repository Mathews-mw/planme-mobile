import 'package:planme/data/models/task.dart';
import 'package:planme/data/models/task_occurrence.dart';
import 'package:planme/data/models/task_with_next_occurrence.dart';
import 'package:planme/domains/recurrence/recurrence_generator.dart';
import 'package:planme/domains/recurrence/models/recurrence_rule.dart';
import 'package:planme/domains/recurrence/models/recurrence_type.dart';

class RecurrenceEngine {
  const RecurrenceEngine();

  List<DateTime> generateOccurrencesForRange({
    required RecurrenceRule rule,
    required DateTime from,
    int? maxOccurrences,
    DateTime? until,
  }) {
    return generateOccurrences(
      rule: rule,
      from: from,
      maxOccurrences: maxOccurrences,
      until: until,
    );
  }

  TaskOccurrence? getNextOccurrenceForTask(Task task, {DateTime? from}) {
    final DateTime reference = from ?? DateTime.now();

    // Task sem data base não tem próxima ocorrência
    if (task.baseDateTime == null) return null;

    // 1) Task NÃO recorrente
    if (task.recurrence == null ||
        task.recurrence!.type == RecurrenceType.none) {
      final dt = task.baseDateTime!;

      // regra de negócio: se já passou, você pode:
      // - retornar null (não mostrar), ou
      // - ainda mostrar como "já aconteceu".
      if (dt.isBefore(reference)) {
        return null;
      }

      return TaskOccurrence(task: task, scheduledAt: dt);
    }

    // 2) Task recorrente: usa o motor para pegar só a próxima
    final rule = task.recurrence!;

    final occs = generateOccurrences(
      rule: rule,
      from: reference,
      maxOccurrences: 1,
    );

    if (occs.isEmpty) return null;

    return TaskOccurrence(task: task, scheduledAt: occs.first);
  }

  /// Gera as ocorrências de todas as tasks entre [from] e [to].
  List<TaskOccurrence> generateOccurrencesInRange({
    required DateTime from,
    required DateTime to,
    required List<Task> tasks,
    int? maxOccurrences = 1,
  }) {
    final List<TaskOccurrence> occurrences = [];

    for (final task in tasks) {
      // Task sem data base = não aparece na agenda
      if (task.baseDateTime == null) continue;

      // 1) Task não recorrente: data única
      if (task.recurrence == null ||
          task.recurrence!.type == RecurrenceType.none) {
        final dt = task.baseDateTime!;
        if (!dt.isBefore(from) && !dt.isAfter(to)) {
          occurrences.add(TaskOccurrence(task: task, scheduledAt: dt));
        }
        continue;
      }

      // 2) Task recorrente: usa o motor de recorrência
      final rule = task.recurrence!;

      final generated = generateOccurrences(rule: rule, from: from, until: to);

      for (final date in generated) {
        occurrences.add(TaskOccurrence(task: task, scheduledAt: date));
      }
    }

    // Ordena por data/hora
    occurrences.sort((a, b) => a.scheduledAt!.compareTo(b.scheduledAt!));

    return occurrences;
  }

  List<TaskWithNextOccurrence> generateTasksWithNextOccurrence({
    required List<Task> tasks,
    DateTime? from,
    bool includePastNonRecurring = false,
  }) {
    final DateTime reference = from ?? DateTime.now();

    final List<TaskWithNextOccurrence> list = [];

    for (final task in tasks) {
      final occ = getNextOccurrenceForTask(task, from: reference);

      if (occ == null) {
        // Se não tem próxima ocorrência:
        // - para task não recorrente que já passou, você decide se mostra ou não.
        if (includePastNonRecurring &&
            (task.recurrence == null ||
                task.recurrence!.type == RecurrenceType.none) &&
            task.baseDateTime != null) {
          list.add(
            TaskWithNextOccurrence(
              task: task,
              nextOccurrenceAt: task.baseDateTime,
            ),
          );
        }
        continue;
      }

      list.add(
        TaskWithNextOccurrence(task: task, nextOccurrenceAt: occ.scheduledAt),
      );
    }

    // Ordena pela próxima ocorrência (as sem data vão pro final)
    list.sort((a, b) {
      if (a.nextOccurrenceAt == null && b.nextOccurrenceAt == null) return 0;
      if (a.nextOccurrenceAt == null) return 1;
      if (b.nextOccurrenceAt == null) return -1;
      return a.nextOccurrenceAt!.compareTo(b.nextOccurrenceAt!);
    });

    return list;
  }
}
