import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_with_getx/ui/controller/task_item_card_controller.dart';
import 'package:task_manager_with_getx/ui/widgets/snack_bar_message.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_model.dart';
import '../../data/models/task_status_list_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/api_urls.dart';
import '../utility/colors.dart';
import 'custom_progress_indicator.dart';

class TaskItemCard extends StatefulWidget {
  const TaskItemCard({
    super.key,
    required this.taskModel,
    required this.onUpdateTask,
  });

  final TaskModel taskModel;
  final VoidCallback onUpdateTask;

  @override
  State<TaskItemCard> createState() => _TaskItemCardState();
}

class _TaskItemCardState extends State<TaskItemCard> {

  final TaskItemCardController taskItemCardController = Get.find<TaskItemCardController>();

  TaskStatusListModel? dropdownValue;
  final List<TaskStatusListModel> statusList = [
    TaskStatusListModel(status: 'New', color: Colors.blue),
    TaskStatusListModel(status: 'Completed', color: AppColors.themeColor),
    TaskStatusListModel(status: 'Canceled', color: AppColors.redColor),
    TaskStatusListModel(status: 'InProgress', color: Colors.pink),
  ];


  @override
  void initState() {
    super.initState();
    dropdownValue = statusList.firstWhere(
        (statusInfo) => statusInfo.status == widget.taskModel.status);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.whiteColor,
      child: ListTile(
        title: Text(
          widget.taskModel.title ?? '',
          style: const TextStyle(fontSize: 20),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.taskModel.description ?? '',
                style: const TextStyle(fontSize: 16)),
            Text(
              'Date: ${widget.taskModel.createdDate}',
              style: const TextStyle(
                color: AppColors.blackColor,
                fontSize: 12,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  label: Text(
                    dropdownValue?.status ?? '',
                    style: const TextStyle(color: AppColors.whiteColor),
                  ),
                  backgroundColor: dropdownValue?.color,
                ),
                ButtonBar(
                  children: [
                    GetBuilder<TaskItemCardController>(
                      builder: (_) {
                        return Visibility(
                          visible: !taskItemCardController.editInProgress,
                          replacement: const CustomProgressIndicator(),
                          child: PopupMenuButton<TaskStatusListModel>(
                            icon: const Icon(
                              Icons.edit_note_rounded,
                              color: AppColors.themeColor,
                            ),
                            onSelected: (TaskStatusListModel selectedValue) {
                              _updateTaskStatus(selectedValue, widget.taskModel);
                            },
                            itemBuilder: (BuildContext context) {
                              return statusList
                                  .map((TaskStatusListModel taskStatus) {
                                return PopupMenuItem<TaskStatusListModel>(
                                  value: taskStatus,
                                  child: ListTile(
                                    title: Text(taskStatus.status),
                                    trailing:
                                        dropdownValue?.status == taskStatus.status
                                            ? const Icon(Icons.done)
                                            : null,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        );
                      }
                    ),
                    IconButton(
                      onPressed: _deleteConfirmationDialog,
                      icon: const Icon(Icons.delete, color: AppColors.redColor),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _deleteConfirmationDialog() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Visibility(
          visible: !taskItemCardController.deleteInProgress,
          replacement: const CustomProgressIndicator(),
          child: AlertDialog(
            title: const Text('Confirmation'),
            content: const Text(
              'Are you sure for Delete',
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Text('NO')),
              IconButton(
                  onPressed: () {
                    _onDeleteTask();
                    Get.back();
                  },
                  icon: const Text('YES')),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onDeleteTask() async {
    bool result = await taskItemCardController.deleteTask(widget.taskModel);
    if (result) {
      widget.onUpdateTask();
      if (mounted) {
        showSnackBarMessage(
          context,
          'Task Deleted Successfully',
        );
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          taskItemCardController.errorMessage,
        );
      }
    }
  }

  Future<void> _updateTaskStatus(TaskStatusListModel taskStatus, TaskModel taskModel) async {

    bool result = await taskItemCardController.updateTaskStatus(taskStatus, taskModel);
    if(result){
      dropdownValue = taskStatus;
      widget.taskModel.status = taskStatus.status;
      widget.onUpdateTask();
      if (mounted) {
        showSnackBarMessage(
          context,
          'Task status updated successfully',
        );
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          taskItemCardController.errorMessage,
        );
      }
    }

  }
}
