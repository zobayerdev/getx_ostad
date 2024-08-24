import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/api_urls.dart';

class ResetPasswordController extends GetxController{

  bool _resetPasswordInProgress = false;
  String _errorMessage = '';
  bool _showNewPassword = true;
  bool _showConfirmNewPassword = true;
  bool get resetPasswordInProgress => _resetPasswordInProgress;
  String get errorMessage => _errorMessage;
  bool get showNewPassword => _showNewPassword;
  bool get showConfirmNewPassword => _showConfirmNewPassword;

  void toggleNewPasswordVisibility (){
    _showNewPassword = !_showNewPassword;
    update();
  }
  void toggleConfirmNewPasswordVisibility (){
    _showConfirmNewPassword = !_showConfirmNewPassword;
    update();
  }


  Future<bool> onTapConfirmResetPassword(String password, String email, String oTP) async {
      bool isSuccess = false;
      _resetPasswordInProgress = true;
      update();

      Map<String, dynamic> requestBody = {
        "email": email,
        "OTP": oTP,
        "password": password,
      };

      NetworkResponse response = await NetworkCaller.postRequest(
        ApiUrls.resetPassword,
        body: requestBody,
      );

      if (response.isSuccess && response.responseData['status'] == 'success') {
        isSuccess = true;
      } else {
        _errorMessage = response.errorMessage ?? 'Password reset failed! Try again';
      }
      _resetPasswordInProgress = false;
      update();
      return isSuccess;
    }
}