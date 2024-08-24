import 'package:get/get.dart';
import 'package:task_manager_with_getx/data/models/task_model.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_count_by_status_model.dart';
import '../../data/models/task_count_by_status_wrapper_model.dart';
import '../../data/models/tasklist_wrapper_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/api_urls.dart';

class NewTaskController extends GetxController{
  bool _getNewTaskInProgress = false;
  bool _getTaskCountByStatusInProgress = false;
  List<TaskModel> _taskList = [];
  List<TaskCountByStatusModel> _taskCountByStatusList = [];
  String _errorMessage = '';

  bool get getNewTaskInProgress => _getNewTaskInProgress;
  bool get getTaskCountByStatusInProgress => _getTaskCountByStatusInProgress;
  List<TaskModel> get newTaskList => _taskList;
  List<TaskCountByStatusModel> get taskCountByStatusList => _taskCountByStatusList;
  String get errorMessage => _errorMessage;

  Future<bool> getTaskCountByStatus() async {
    bool isSuccess = false;
    _getTaskCountByStatusInProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(ApiUrls.taskStatusCount);
    if (response.isSuccess) {
      TaskCountByStatusWrapperModel taskCountByStatusWrapperModel =
      TaskCountByStatusWrapperModel.fromJson(response.responseData);
      _taskCountByStatusList =
          taskCountByStatusWrapperModel.taskCountByStatusList ?? [];
    } else {
     _errorMessage = response.errorMessage ?? 'Get task Count by status failed! Try again';
    }
    _getTaskCountByStatusInProgress = false;
    update();
    return isSuccess;
  }

  Future<bool> getNewTask() async {
    bool isSuccess = false;
    _getNewTaskInProgress = true;
    update();
    NetworkResponse response = await NetworkCaller.getRequest(ApiUrls.newTask);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      _taskList = taskListWrapperModel.taskList ?? [];
    } else {
      _errorMessage = response.errorMessage ?? 'Get new task failed! Try again';
    }

    _getNewTaskInProgress = false;
    update();
    return isSuccess;
  }
}
