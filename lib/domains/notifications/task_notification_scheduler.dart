import 'package:planme/data/models/task.dart';
import 'package:planme/domains/recurrence/recurrence_engine.dart';
import 'package:planme/domains/notifications/services/local_notifications_service.dart';

class TaskNotificationScheduler {
  final LocalNotificationsService _notifications;
  final RecurrenceEngine _recurrenceEngine;

  TaskNotificationScheduler({
    LocalNotificationsService? notifications,
    RecurrenceEngine? recurrenceEngine,
  }) : _notifications = notifications ?? LocalNotificationsService.instance,
       _recurrenceEngine = recurrenceEngine ?? RecurrenceEngine();

  // ID estável pra cada task gerado a partir do id da task
  int _notificationIdForTask(String taskId) {
    return taskId.hashCode & 0x7fffffff;
  }

  /// Agenda a PRÓXIMA ocorrência de uma task (se existir)
  Future<void> scheduleForTask(Task task) async {
    final now = DateTime.now();

    // Usa a função que calcula nextOccurrence
    final next = _recurrenceEngine.getNextOccurrenceForTask(task, from: now);

    if (next == null) return;

    final taskId = _notificationIdForTask(task.id);

    print(
      'The task notification will be on: ${next.scheduledAt} for the task: ${next.task.title}',
    );

    await _notifications.scheduleNotification(
      id: taskId,
      dateTime: next.scheduledAt,
      title: task.title,
      body: task.description ?? 'Task reminder',
      payload: task.id, // para saber qual task abrir
    );
  }

  /// Cancela notificação de uma task específica através do taskId
  Future<void> cancelForTask(String taskId) async {
    final id = _notificationIdForTask(taskId);
    await _notifications.cancelNotification(id);
  }

  /// Re-sincroniza tudo (Pode ser chamado ao abrir o app)
  Future<void> resyncAll(List<Task> tasks) async {
    print('Start resync all notifications...');

    await _notifications.cancelAllNotifications();

    final now = DateTime.now();

    for (final task in tasks) {
      print('Resync task: ${task.title}');
      final next = _recurrenceEngine.getNextOccurrenceForTask(task, from: now);

      if (next != null) {
        print('Next notification will be on: ${next.scheduledAt}');
        final taskId = _notificationIdForTask(task.id);
        await _notifications.scheduleNotification(
          id: taskId,
          dateTime: next.scheduledAt,
          title: task.title,
          body: task.description ?? 'Task reminder',
          payload: task.id,
        );
      }
    }

    print('Resync completed!');
  }
}
