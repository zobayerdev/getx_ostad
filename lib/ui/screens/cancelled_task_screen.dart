import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_with_getx/ui/controller/cancelled_task_controller.dart';
import '../widgets/custom_progress_indicator.dart';
import '../widgets/task_item_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  final CancelledTaskController cancelledTaskController = Get.find<CancelledTaskController>();

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
    child: GetBuilder<CancelledTaskController>(
      builder: (_) {
        return Visibility(
        visible: !cancelledTaskController.getCancelledTaskInProgress,
        replacement: const CustomProgressIndicator(),
              child: cancelledTaskController.cancelledTaskList.isEmpty
                  ? Center(
                  child: Text('No Cancelled Task Available',
                      style: Theme.of(context).textTheme.titleMedium))
                  :  ListView.builder(
                itemCount: cancelledTaskController.cancelledTaskList.length,
                itemBuilder: (context, index) {
                  return TaskItemCard(taskModel: cancelledTaskController.cancelledTaskList[index],
                    onUpdateTask: () {
                      _initialLoading();
                    },);
                },
              ),
            );
      }
    ),
      ),),
    );
  }
  Future<void> _initialLoading() async {
    await cancelledTaskController.getCancelledTask();
  }
}
