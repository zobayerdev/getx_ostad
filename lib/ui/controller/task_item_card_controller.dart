import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_model.dart';
import '../../data/models/task_status_list_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/api_urls.dart';
import '../utility/colors.dart';

class TaskItemCardController extends GetxController {

  String _errorMessage = '';
  bool _deleteInProgress = false;
  bool _editInProgress = false;

  String get errorMessage => _errorMessage;
  bool get deleteInProgress => _deleteInProgress;
  bool get editInProgress => _editInProgress;
  //TaskStatusListModel? get dropdownValue => _dropdownValue;
  //List<TaskStatusListModel> get statusList => _statusList;

  Future<bool> deleteTask(TaskModel taskModel) async {
    bool isSuccess = false;
    _deleteInProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(
        ApiUrls.deleteTask(taskModel.sId!));

    if (response.isSuccess) {
      isSuccess = true;
      update();
    } else {
      _errorMessage = response.errorMessage ?? 'Failed to delete task! Try again';
    }
    _deleteInProgress = false;
    update();
    return isSuccess;
  }


  Future<bool> updateTaskStatus(TaskStatusListModel taskStatus, TaskModel taskModel) async {
    bool isSuccess =  false;
    _editInProgress = true;
    update();
    NetworkResponse response = await NetworkCaller.getRequest(
        ApiUrls.updateTaskStatus(taskModel.sId!, taskStatus.status));

    if (response.isSuccess) {
      isSuccess = true;
      update();
    } else {
      _errorMessage = response.errorMessage ?? 'Failed to update task status! Try again';
    }
    _editInProgress = false;
    update();
    return isSuccess;
  }
}
