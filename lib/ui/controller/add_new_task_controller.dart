import 'package:get/get.dart';
import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/api_urls.dart';

class AddNewTaskController extends GetxController{
  bool _addNewTaskInProgress = false;
  String _errorMessage = '';

  bool get addNewTaskInProgress => _addNewTaskInProgress;
  String get errorMessage => _errorMessage;

  Future<bool> addNewTask(String title, String description) async {

    bool isSuccess = false;
    _addNewTaskInProgress = true;
    update();
    Map<String, dynamic> requestTaskData = {
      "title": title,
      "description": description,
      "status": "New",
    };

    NetworkResponse response = await NetworkCaller.postRequest(
        ApiUrls.createTask,
        body: requestTaskData);

    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Failed to add new task! Try again';
    }
    _addNewTaskInProgress = false;
    update();
    return isSuccess;
  }
}
