import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:planme/theme/app_colors.dart';
import 'package:planme/components/custom_app_bar.dart';
import 'package:planme/ui/screens/tabs/agenda_tab.dart';
import 'package:planme/ui/screens/tabs/all_tasks_tab.dart';
import 'package:planme/ui/screens/home/create_task_bottom_sheet.dart';
import 'package:planme/ui/screens/starred_tasks/starred_tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, initialIndex: 1, vsync: this);
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: CustomAppBar(
        title: 'Hi, Mathews',
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          // isScrollable: true,
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
          children: [StarredTasksScreen(), AllTasksTab(), AgendaTab()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateTaskBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
