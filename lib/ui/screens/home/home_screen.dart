import 'package:flutter/material.dart';
import 'package:planme/domains/notifications/services/local_notifications_service.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:planme/app_router.dart';
import 'package:planme/theme/app_colors.dart';
import 'package:planme/providers/tasks_provider.dart';
import 'package:planme/components/custom_app_bar.dart';
import 'package:planme/ui/screens/tasks_tabs/agenda_tab.dart';
import 'package:planme/data/models/aggregates/task_details.dart';
import 'package:planme/ui/screens/tasks_tabs/all_tasks_tab.dart';
import 'package:planme/ui/screens/tasks_tabs/starred_tasks_tab.dart';
import 'package:planme/ui/screens/home/create_task_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _isLoading = true;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<TasksProvider>().loadAllTasks();

      if (mounted) {
        setState(() => _isLoading = false);
      }
    });

    _tabController = TabController(length: 3, initialIndex: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> showCreateTaskBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return const CreateTaskBottomSheet();
      },
    );
  }

  Future<void> _navigateToTaskDetails(String taskId) async {
    final result = await context.pushNamed<(bool, TaskDetails?)>(
      AppRouter.taskDetails,
      pathParameters: {'taskId': taskId},
    );

    if (!mounted) return;

    if (result != null && result.$1) {
      final deletedTask = result.$2;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task deleted'),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () async {
              if (deletedTask != null) {
                await context.read<TasksProvider>().restoreTask(deletedTask);
              }
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: CustomAppBar(
        title: 'Hi, Mathews',
        actions: [
          IconButton(
            onPressed: () async {
              final notificationService = LocalNotificationsService.instance;

              await notificationService.showNotification(
                title: 'Task notification',
                body:
                    'Remind you about New task. It is start on 12 Dec at 7:30 AM.',
              );
            },
            icon: Icon(Icons.send),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          // isScrollable: true,
          tabAlignment: TabAlignment.fill,
          dividerHeight: 1,
          indicatorColor: AppColors.purpleBase,
          labelColor: AppColors.purpleBase,
          tabs: <Widget>[
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(PhosphorIconsFill.star, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Favorites',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(PhosphorIconsFill.sticker, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'All Tasks',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(PhosphorIconsFill.notebook, size: 20),
                  SizedBox(width: 8),
                  Text('Agenda', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            StarredTasksTab(navigateToTaskDetails: _navigateToTaskDetails),
            AllTasksTab(navigateToTaskDetails: _navigateToTaskDetails),
            AgendaTab(navigateToTaskDetails: _navigateToTaskDetails),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateTaskBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
