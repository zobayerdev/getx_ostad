import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_with_getx/ui/controller/update_profile_controller.dart';
import 'package:task_manager_with_getx/ui/widgets/custom_progress_indicator.dart';
import 'package:task_manager_with_getx/ui/widgets/custom_textformfield.dart';
import '../../data/models/network_response.dart';
import '../../data/models/user_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/api_urls.dart';
import '../controller/auth_controller.dart';
import '../utility/strings.dart';
import '../widgets/background_widget.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/title_large_text_widget.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key,});


  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileNumberTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final UpdateProfileController updateProfileController = Get.find<UpdateProfileController>();


  @override
  void initState() {
    final userData = AuthController.userData!;
    super.initState();
    _emailTEController.text = userData.email ?? '';
    _firstNameTEController.text = userData.firstName ?? '';
    _lastNameTEController.text = userData.lastName ?? '';
    _mobileNumberTEController.text = userData.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context, true),
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 35),
                    const TitleLargeText(titleLarge: updateProfileScreenTitle),
                    const SizedBox(height: 16),
                    _buildPhotoPickerWidget(),
                    const SizedBox(height: 12),
                    CustomTextFormField(
                      controller: _emailTEController,
                      hintText: 'Email',
                      keyBoardType: TextInputType.emailAddress,
                      validatorErrorText: 'Update Your Email',
                      regExpErrorText: 'Enter a valid email address',
                      isRegExpValidation: true,
                      isEnabled: false,
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _firstNameTEController,
                      hintText: 'First Name',
                      validatorErrorText: 'Update Your First Name',
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _lastNameTEController,
                      hintText: 'Last Name',
                      validatorErrorText: 'Update Your Last Name',
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _mobileNumberTEController,
                      hintText: 'Mobile',
                      keyBoardType: TextInputType.number,
                      validatorErrorText: 'Update Your Mobile Number',
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _passwordTEController,
                      hintText: 'Password',
                      isValidate: false,
                    ),
                    const SizedBox(height: 16),
                    GetBuilder<UpdateProfileController>(
                      builder: (_) {
                        return Visibility(
                          visible: !updateProfileController.updateProfileInProgress,
                          replacement: const CustomProgressIndicator(),
                          child: ElevatedButton(
                            onPressed: _onTapUpdateProfileButton,
                            child: const Icon(Icons.arrow_circle_right_outlined),
                          ),
                        );
                      }
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPickerWidget() {
    return GetBuilder<UpdateProfileController>(
      builder: (_) {
        return GestureDetector(
          onTap: updateProfileController.pickProfileImage,
          child: Container(
            width: double.maxFinite,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 48,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                      color: Colors.grey),
                  alignment: Alignment.center,
                  child: const Text(
                    'Photo',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    updateProfileController.selectedImage?.name ?? 'No image selected',
                    maxLines: 1,
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Future<void> _onTapUpdateProfileButton() async {
    if (_formKey.currentState!.validate()) {
             String email = _emailTEController.text;
             String password = _emailTEController.text;
             String firstName = _firstNameTEController.text.trim();
             String lastName = _lastNameTEController.text.trim();
             String mobile = _mobileNumberTEController.text.trim();

      bool result = await updateProfileController.updateProfile(email, password, firstName, lastName, mobile);
      if(result){
        if (mounted) {
                showSnackBarMessage(context, 'Profile updated!');
        }
      } else {
        if (mounted) {
          showSnackBarMessage(context, updateProfileController.errorMessage);
        }
      }
    }
  }

  // Future<void> _updateProfile() async {
  //   _updateProfileInProgress = true;
  //   String encodePhoto = AuthController.userData?.photo ?? '';
  //   if (mounted) {
  //     setState(() {});
  //   }
  //
  //   Map<String, dynamic> requestBody = {
  //     "email": _emailTEController.text,
  //     "firstName":_firstNameTEController.text.trim(),
  //     "lastName":_lastNameTEController.text.trim(),
  //     "mobile":_mobileNumberTEController.text.trim(),
  //   };
  //   if(_passwordTEController.text.isNotEmpty){
  //     requestBody['password'] = _passwordTEController.text;
  //   }
  //   if(_selectedImage != null){
  //     File file = File(_selectedImage!.path);
  //     encodePhoto = base64Encode(file.readAsBytesSync());
  //     requestBody['photo'] = encodePhoto;
  //   }
  //
  //   NetworkResponse response =
  //   await NetworkCaller.postRequest(ApiUrls.updateProfile, body: requestBody);
  //   if (response.isSuccess && response.responseData['status'] == 'success') {
  //     UserModel userModel = UserModel(
  //       email: _emailTEController.text,
  //       firstName: _firstNameTEController.text.trim(),
  //       lastName: _lastNameTEController.text.trim(),
  //       mobile: _mobileNumberTEController.text.trim(),
  //       photo: encodePhoto,
  //     );
  //     await AuthController.saveUserData(userModel);
  //     if (mounted) {
  //       showSnackBarMessage(context,
  //           'Profile updated!');
  //     }
  //   } else {
  //     if (mounted) {
  //       showSnackBarMessage(context,
  //           response.errorMessage ?? 'Get in progress task failed! Try again');
  //     }
  //   }
  //   _updateProfileInProgress = false;
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  // Future<void> _pickProfileImage() async {
  //   final imagePicker = ImagePicker();
  //   final XFile? result =
  //       await imagePicker.pickImage(source: ImageSource.gallery);
  //   if (result != null) {
  //     _selectedImage = result;
  //     if (mounted) {
  //       setState(() {});
  //     }
  //   }
  // }
}
