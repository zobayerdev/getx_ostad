import 'package:get/get.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_model.dart';
import '../../data/models/tasklist_wrapper_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/api_urls.dart';

class InProgressTaskController extends GetxController{
  List<TaskModel> _inProgressTaskList = [];
  bool _inProgressTaskInProgress = true;
  String _errorMessage = '';

  List<TaskModel> get inProgressTaskList => _inProgressTaskList;
  bool get inProgressTaskInProgress => _inProgressTaskInProgress;

  Future<bool> getInProgressTask() async {
    bool isSuccess = false;
    _inProgressTaskInProgress = true;
    update();

    NetworkResponse response =
    await NetworkCaller.getRequest(ApiUrls.inProgressTask);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      _inProgressTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      _errorMessage = response.errorMessage ?? 'Get in progress task failed! Try again';
    }
    _inProgressTaskInProgress = false;
    update();
    return isSuccess;
  }
}