import 'package:get/get.dart';
import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/api_urls.dart';

class SignUpController extends GetxController {

  bool _registrationInProgress =  false;
  String _errorMessage =  '';
  bool _showPassword = true;
  bool get registrationInProgress =>  _registrationInProgress;
  String get errorMessage => _errorMessage;

  bool get showPassword => _showPassword;

  void togglePasswordVisibility (){
    _showPassword = !_showPassword;
    update();
  }


  Future<bool> registerUser(String email, String password, String firstName, String lastName, String mobile) async {

    bool isSuccess = false;
    _registrationInProgress = true;
    update();

    Map<String, dynamic> requestUserRegistration = {
      "email" : email,
      "firstName" : firstName,
      "lastName" : lastName,
      "mobile" : mobile,
      "password" : password,
      "photo" : ""
    };

    NetworkResponse response = await NetworkCaller.postRequest(ApiUrls.registration, body: requestUserRegistration);

    if (response.isSuccess){
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Registration failed! Try again';
    }
    _registrationInProgress = false;
    update();
    return isSuccess;
  }
}
