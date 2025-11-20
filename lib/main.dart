import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:planme/theme/theme.dart';
import 'package:planme/ui/screens/tasks/tasks_screen.dart';
import 'package:planme/providers/tasks_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TasksProvider())],
      child: MaterialApp(
        title: 'Plan Me',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        themeMode: ThemeMode.light,
        home: const TasksScreen(),
      ),
    );
  }
}
