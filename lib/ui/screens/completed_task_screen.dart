import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_with_getx/ui/controller/completed_task_controller.dart';
import '../widgets/custom_progress_indicator.dart';
import '../widgets/task_item_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  final CompletedTaskController completedTaskController = Get.find<CompletedTaskController>();

  @override
  void initState() {
    super.initState();
    _initialLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: RefreshIndicator(
          onRefresh: _initialLoading,
          child: GetBuilder<CompletedTaskController>(
            builder: (_) {
              return Visibility(
                visible: !completedTaskController.getCompletedTaskInProgress,
                replacement: const CustomProgressIndicator(),
                child: completedTaskController.completeTaskList.isEmpty
                    ? Center(
                        child: Text('No Completed Task Available',
                            style: Theme.of(context).textTheme.titleMedium),
                      )
                    : ListView.builder(
                        itemCount: completedTaskController.completeTaskList.length,
                        itemBuilder: (context, index) {
                          return TaskItemCard(
                            taskModel: completedTaskController.completeTaskList[index],
                            onUpdateTask: () {
                              _initialLoading();
                            },
                          );
                        },
                      ),
              );
            }
          ),
        ),
      ),
    );
  }
  Future<void> _initialLoading() async {
    await completedTaskController.getCompletedTask();
  }
}
