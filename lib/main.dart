import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:planme/app_router.dart';
import 'package:planme/theme/theme.dart';
import 'package:planme/providers/tasks_provider.dart';
import 'package:planme/providers/subtasks_provider.dart';
import 'package:planme/data/repositories/tasks_repository.dart';
import 'package:planme/data/repositories/subtasks_repository.dart';
import 'package:planme/data/database/isar/local_database_service.dart';
import 'package:planme/domains/notifications/task_notification_scheduler.dart';
import 'package:planme/domains/notifications/services/local_notifications_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('en-US', null);

  await LocalDatabaseService().initialize();

  await LocalNotificationsService.instance.initNotifications();
  LocalNotificationsService.instance.getPermissions();

  // final details = await LocalNotificationsService.instance.notificationsPlugin
  //     .getNotificationAppLaunchDetails();

  // if (details?.didNotificationLaunchApp ?? false) {
  //   final payload = details!.notificationResponse?.payload;
  //   final actionId = details!.notificationResponse?.actionId;

  //   // aqui dá pra mandar direto pro handler onNotificationAction
  //   print('Notification payload: $payload | Notification action: $actionId');
  // }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  late final TasksRepository tasksRepository;
  late final SubtasksRepository subtasksRepository;
  late final TaskNotificationScheduler notificationScheduler;

  MyApp({super.key}) {
    tasksRepository = TasksRepository();
    subtasksRepository = SubtasksRepository();
    notificationScheduler = TaskNotificationScheduler();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Handler para qualquer clique das notificações
    LocalNotificationsService
        .instance
        .onNotificationAction = (String taskId, String? actionId) async {
      if (!mounted) return;

      // Ação "complete task"
      if (actionId == 'complete_task') {
        final tasksProvider = context.read<TasksProvider>();

        await tasksProvider.toggleCompleted(taskId: taskId, isCompleted: true);

        // await tasksProvider.scheduleNextOccurrenceNotification(taskId);

        return;
      }

      // Apenas navegar para tela de detalhes da task
      AppRouter.router.pushNamed(
        AppRouter.taskDetails,
        pathParameters: {'taskId': taskId},
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              SubtasksProvider(subtasksRepository: widget.subtasksRepository),
        ),
        ChangeNotifierProxyProvider<SubtasksProvider, TasksProvider>(
          create: (context) {
            final subtasks = Provider.of<SubtasksProvider>(
              context,
              listen: false,
            );

            return TasksProvider(
              subtasksProvider: subtasks,
              tasksRepository: widget.tasksRepository,
              notificationScheduler: widget.notificationScheduler,
            );
          },
          update: (context, subtasks, previous) {
            // se quiser atualizar a referência depois:
            return previous ??
                TasksProvider(
                  subtasksProvider: subtasks,
                  tasksRepository: widget.tasksRepository,
                  notificationScheduler: widget.notificationScheduler,
                );
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'Plan Me',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', 'US'), Locale('pt', 'BR')],
        themeMode: ThemeMode.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
