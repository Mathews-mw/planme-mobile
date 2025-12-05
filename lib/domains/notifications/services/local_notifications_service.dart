import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsService {
  static final LocalNotificationsService _instance =
      LocalNotificationsService._internal();

  factory LocalNotificationsService() => _instance;

  LocalNotificationsService._internal();

  static LocalNotificationsService get instance => _instance;

  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// callback que a camada de UI/app vai registrar
  void Function(String taskId, String? actionId)? onNotificationAction;

  Future<void> initNotifications() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();
    final currentTimeZoneInfo = await FlutterTimezone.getLocalTimezone();
    final currentTimeZone = currentTimeZoneInfo.identifier;

    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    // Android init Settings
    const initAndroidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );

    // iOS init Settings
    final initIOsSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [
        DarwinNotificationCategory(
          'task_reminder',
          actions: [
            DarwinNotificationAction.plain(
              'complete_task', // actionId
              'Complete',
            ),
          ],
        ),
      ],
    );

    final initSettings = InitializationSettings(
      android: initAndroidSettings,
      iOS: initIOsSettings,
    );

    await notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final taskId = response.payload;

        if (taskId == null) return;

        // Tap simples na notificação → actionId == null || Tap no botão "Complete" → actionId == 'complete_task';
        final actionId = response.actionId;

        onNotificationAction?.call(taskId, actionId);
      },
    );
    _isInitialized = true;
  }

  void getPermissions() {
    if (!_isInitialized) {
      throw Exception(
        'Error: The notification service has not yet been initialized!',
      );
    }

    notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'planme_channel_id',
        'Remind task',
        channelDescription: 'Task notifications channel',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/launcher_icon',
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            'complete_task', // actionId
            'Complete',
            // Os 2 prx parâmetros são para não abrir UI e só processar em background:
            showsUserInterface: false,
            cancelNotification: true,
          ),
        ],
      ),
      iOS: DarwinNotificationDetails(categoryIdentifier: 'task_reminder'),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    if (!_isInitialized) {
      throw Exception(
        'Error: The notification service has not yet been initialized!',
      );
    }

    return notificationsPlugin.show(id, title, body, notificationDetails());
  }

  Future<void> scheduleNotification({
    required int id,
    required DateTime dateTime,
    String? title,
    String? body,
    String? payload,
  }) async {
    if (!_isInitialized) {
      throw Exception(
        'Error: The notification service has not yet been initialized!',
      );
    }

    final tzDateTime = tz.TZDateTime.from(dateTime, tz.local);

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzDateTime,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: null, // Send notification only once,
      payload: payload,
    );
  }

  Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }
}
