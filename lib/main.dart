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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('en-US', null);

  await LocalDatabaseService().initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late final TasksRepository tasksRepository;
  late final SubtasksRepository subtasksRepository;

  MyApp({super.key}) {
    tasksRepository = TasksRepository();
    subtasksRepository = SubtasksRepository();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              SubtasksProvider(subtasksRepository: subtasksRepository),
        ),
        ChangeNotifierProxyProvider<SubtasksProvider, TasksProvider>(
          create: (context) {
            final subtasks = Provider.of<SubtasksProvider>(
              context,
              listen: false,
            );

            return TasksProvider(
              subtasksProvider: subtasks,
              tasksRepository: tasksRepository,
            );
          },
          update: (context, subtasks, previous) {
            // se quiser atualizar a referência depois:
            return previous ??
                TasksProvider(
                  subtasksProvider: subtasks,
                  tasksRepository: tasksRepository,
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
