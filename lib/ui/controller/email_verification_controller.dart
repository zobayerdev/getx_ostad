import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/api_urls.dart';

class EmailVerificationController extends GetxController {

  bool _emailVrificationInprogress = false;
  String _errorMessage = '';

  bool get emailVrificationInprogress => _emailVrificationInprogress;
  String get errorMessage => _errorMessage;

  Future<bool> onConfirmVerifyEmail(String email) async {
    bool isSuccess = false;
    _emailVrificationInprogress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(
        ApiUrls.recoverVerifyEmail(email));


    if (response.isSuccess && response.responseData['status'] == 'success') {
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Email verification failed! Try again';
    }
    _emailVrificationInprogress = false;
    update();
    return isSuccess;
  }
}
