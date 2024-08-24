import 'package:get/get.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_model.dart';
import '../../data/models/tasklist_wrapper_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/api_urls.dart';

class CompletedTaskController extends GetxController{
  List<TaskModel> _completedTaskList = [];
  bool _getCompletedTaskInProgress = false;
  String _errorMessage = '';

  List<TaskModel> get completeTaskList => _completedTaskList;
  bool get getCompletedTaskInProgress => _getCompletedTaskInProgress;
  String get errorMessage => _errorMessage;

  Future<bool> getCompletedTask() async {
    bool isSuccess = false;
    _getCompletedTaskInProgress = true;
    update();

    NetworkResponse response =
    await NetworkCaller.getRequest(ApiUrls.completedTask);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      _completedTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      _errorMessage = response.errorMessage ?? 'Get new task failed! Try again';
    }
    _getCompletedTaskInProgress = false;
    update();
    return isSuccess;
  }

}