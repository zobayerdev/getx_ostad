import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/network_response.dart';
import '../../data/models/user_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/api_urls.dart';
import 'auth_controller.dart';

class UpdateProfileController extends GetxController{
  bool _updateProfileInProgress = false;
  String _errorMessage = '';
  XFile? _selectedImage;

  bool get updateProfileInProgress => _updateProfileInProgress;
  String get errorMessage => _errorMessage;
  XFile? get selectedImage => _selectedImage;

  Future<bool> updateProfile(String email, String password, String firstName, String lastName, String mobile) async {
    bool isSuccess = false;
    _updateProfileInProgress = true;
    String encodePhoto = AuthController.userData?.photo ?? '';
    update();

    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    if(password.isNotEmpty){
      requestBody['password'] = password;
    }

    if(_selectedImage != null){
      File file = File(_selectedImage!.path);
      encodePhoto = base64Encode(file.readAsBytesSync());
      requestBody['photo'] = encodePhoto;
    }

    NetworkResponse response =
    await NetworkCaller.postRequest(ApiUrls.updateProfile, body: requestBody);
    if (response.isSuccess && response.responseData['status'] == 'success') {
      UserModel userModel = UserModel(
        email: email,
        firstName: firstName,
        lastName: lastName,
        mobile: mobile,
        photo: encodePhoto,
      );
      await AuthController.saveUserData(userModel);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Get in progress task failed! Try again';
    }
    _updateProfileInProgress = false;
    update();
    return isSuccess;
  }

  Future<void> pickProfileImage() async {
    final imagePicker = ImagePicker();
    final XFile? result =
    await imagePicker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      _selectedImage = result;
      update();
    }
  }
}