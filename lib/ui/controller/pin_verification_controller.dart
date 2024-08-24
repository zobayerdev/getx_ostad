import 'dart:ui';

import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/api_urls.dart';

class PinVerificationController extends GetxController {
  bool _pinVrificationInprogress = false;
  String _errorMessage = '';

  bool get pinVrificationInprogress => _pinVrificationInprogress;
  String get errorMessage => _errorMessage;

  Future<bool> onTapPinVarify(String recoveryEmail, String oTP) async {

      bool isSuccess = false;
    _pinVrificationInprogress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(
        ApiUrls.recoverVerifyOTP(recoveryEmail, oTP));

    if (response.isSuccess && response.responseData['status'] == 'success') {
      isSuccess = true;
    } else {
      _errorMessage = 'Pin verification failed! Try again';
    }
      _pinVrificationInprogress = false;
      update();
      return isSuccess;
  }
}
