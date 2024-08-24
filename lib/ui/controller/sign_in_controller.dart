import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../data/models/login_model.dart';
import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/api_urls.dart';
import 'auth_controller.dart';

class SignInController extends GetxController{
  bool _signInApiInProgress = false;
  String _errorMessage = '';
  bool _showPassword = true;
  bool get signInApiInProgress => _signInApiInProgress;
  String get errorMessage => _errorMessage;
  bool get showPassword => _showPassword;

  void togglePasswordVisibility (){
    _showPassword = !_showPassword;
    update();
  }

  Future<bool> signIn(String email, String password) async {
    bool isSuccess = false;
    _signInApiInProgress = true;
    update();
    Map<String, dynamic> logInDtata = {
      'email': email,
      'password': password,
    };
    final NetworkResponse response =
    await NetworkCaller.postRequest(ApiUrls.logIn, body: logInDtata);

    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await AuthController.saveUserAccessToken(loginModel.token!);
      await AuthController.saveUserData(loginModel.userModel!);
      isSuccess = true;
    } else {
      _errorMessage =  response.errorMessage ?? 'Incorrect Email or Password! Try Again';
      debugPrint(_errorMessage);
    }
    _signInApiInProgress = false;
    update();
    return isSuccess;
  }
}