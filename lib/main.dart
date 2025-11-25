import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:planme/app_routes.dart';
import 'package:planme/theme/theme.dart';
import 'package:planme/providers/tasks_provider.dart';
import 'package:planme/providers/subtasks_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('en-US', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubtasksProvider()),
        // TasksProvider needs the SubtasksProvider
        ChangeNotifierProxyProvider<SubtasksProvider, TasksProvider>(
          create: (context) {
            final subtasks = Provider.of<SubtasksProvider>(
              context,
              listen: false,
            );
            return TasksProvider(subtasksProvider: subtasks);
          },
          update: (context, subtasks, previous) {
            // se quiser atualizar a referência depois:
            return previous ?? TasksProvider(subtasksProvider: subtasks);
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
