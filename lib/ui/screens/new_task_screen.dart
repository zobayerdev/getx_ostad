import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_with_getx/ui/controller/new_task_controller.dart';
import 'package:task_manager_with_getx/ui/widgets/snack_bar_message.dart';
import '../utility/colors.dart';
import '../widgets/custom_progress_indicator.dart';
import '../widgets/task_item_card.dart';
import '../widgets/task_summary_card.dart';
import 'add_new_task_screen.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final NewTaskController newTaskController = Get.find<NewTaskController>();

  @override
  void initState() {
    super.initState();
    _initialLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _initialLoading,
        child: GetBuilder<NewTaskController>(
            builder: (_) {
            return Visibility(
              visible: newTaskController.getNewTaskInProgress == false,
              replacement: const CustomProgressIndicator(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    buildSummarySection(),
                    const SizedBox(height: 8),
                    Expanded(
                      child: newTaskController.newTaskList.isEmpty
                          ? Center(
                              child: Text('No New Task Available',
                                  style: Theme.of(context).textTheme.titleMedium))
                          : ListView.builder(
                              itemCount: newTaskController.newTaskList.length,
                              itemBuilder: (context, index) {
                                return TaskItemCard(
                                  taskModel: newTaskController.newTaskList[index],
                                  onUpdateTask: () {
                                    _initialLoading();
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddNewButton,
        tooltip: 'Add New Task',
        backgroundColor: AppColors.themeColor,
        foregroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Builder(
          builder: (context) {
            return const Icon(Icons.add);
          }
        ),
      ),
    );
  }

  Widget buildSummarySection() {
    return GetBuilder<NewTaskController>(
      builder: (_) {
        return Visibility(
          visible: newTaskController.getTaskCountByStatusInProgress == false,
          replacement:
              const SizedBox(height: 100, child: CustomProgressIndicator()),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: newTaskController.taskCountByStatusList.map((e) {
                return TaskSummaryCard(
                  title: (e.sId ?? 'Unknown').toUpperCase(),
                  count: e.sum.toString(),
                );
              }).toList(),
            ),
          ),
        );
      }
    );
  }

  void _onTapAddNewButton() {
    Get.to(() => AddNewTaskScreen(
                  onTaskAdded: () {
                    _initialLoading();
                  },
    ),
    );
  }
  Future<void> _initialLoading() async {
    await newTaskController.getTaskCountByStatus();
    await newTaskController.getNewTask();
  }
}
