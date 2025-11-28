import 'package:go_router/go_router.dart';

import 'package:planme/data/models/task.dart';
import 'package:planme/ui/screens/home/home_screen.dart';
import 'package:planme/ui/screens/edit_task/edit_task_screen.dart';
import 'package:planme/ui/screens/task_details/task_details_screen.dart';

class AppRouter {
  static const home = 'home';
  static const taskDetails = 'task-details';
  static const editTask = 'edit-task';

  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        name: AppRouter.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/tasks',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: ':taskId',
            name: AppRouter.taskDetails,
            builder: (context, state) {
              final taskId = state.pathParameters['taskId']!;
              return TaskDetailsScreen(taskId: taskId);
            },
          ),
          GoRoute(
            path: ':taskId/edit',
            name: AppRouter.editTask,
            builder: (context, state) {
              final taskId = state.pathParameters['taskId']!;
              final task = state.extra as Task;
              return EditTaskScreen(taskId: taskId, task: task);
            },
          ),
        ],
      ),
    ],
  );
}
