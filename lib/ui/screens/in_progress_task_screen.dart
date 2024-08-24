import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_with_getx/ui/controller/in_progress_task_controller.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_model.dart';
import '../../data/models/tasklist_wrapper_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/api_urls.dart';
import '../widgets/custom_progress_indicator.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_item_card.dart';
import '../widgets/title_large_text_widget.dart';

class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({super.key});

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
  final InProgressTaskController inProgressTaskController = Get.find<InProgressTaskController>();

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
          child: GetBuilder<InProgressTaskController>(
            builder: (_) {
              return Visibility(
                visible: !inProgressTaskController.inProgressTaskInProgress,
                replacement: const CustomProgressIndicator(),
                child: inProgressTaskController.inProgressTaskList.isEmpty
                    ? Center(
                        child: Text('No In Progress Task Available',
                            style: Theme.of(context).textTheme.titleMedium))
                    : ListView.builder(
                        itemCount: inProgressTaskController.inProgressTaskList.length,
                        itemBuilder: (context, index) {
                          return TaskItemCard(
                            taskModel: inProgressTaskController.inProgressTaskList[index],
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
    await inProgressTaskController.getInProgressTask();
  }
}
