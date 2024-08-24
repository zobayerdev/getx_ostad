import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_model.dart';
import '../../data/models/tasklist_wrapper_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/api_urls.dart';

class CancelledTaskController extends GetxController{
  List<TaskModel> _cancelledTaskList = [];
  bool _getCancelledTaskInProgress = false;
  String _errorMessage = '';

  List<TaskModel> get cancelledTaskList => _cancelledTaskList;
  bool get getCancelledTaskInProgress => _getCancelledTaskInProgress;
  String get errorMessage => _errorMessage;


  Future<bool> getCancelledTask() async {
    bool isSuccess = false;
    _getCancelledTaskInProgress = true;
    update();

    NetworkResponse response =
    await NetworkCaller.getRequest(ApiUrls.canceledTask);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      _cancelledTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      _errorMessage = response.errorMessage ?? 'Get new task failed! Try again';
    }

    _getCancelledTaskInProgress = false;
    update();
    return isSuccess;
  }
}