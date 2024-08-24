import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_with_getx/ui/controller/sign_up_controller.dart';
import '../../utility/colors.dart';
import '../../utility/strings.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/custom_textformfield.dart';
import '../../widgets/snack_bar_message.dart';
import '../../widgets/title_large_text_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileNumberTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final SignUpController signUpController = Get.find<SignUpController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),
                    const TitleLargeText(titleLarge: signUpScreenTitle),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: _emailTEController,
                      hintText: 'Email',
                      keyBoardType: TextInputType.emailAddress,
                      validatorErrorText: 'Enter Your Email',
                      regExpErrorText: 'Enter a valid email address',
                      isRegExpValidation: true,
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _firstNameTEController,
                      hintText: 'First Name',
                      validatorErrorText: 'Enter Your First Name',
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _lastNameTEController,
                      hintText: 'Last Name',
                      validatorErrorText: 'Enter Your Last Name',
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _mobileNumberTEController,
                      keyBoardType: TextInputType.number,
                      hintText: 'Mobile',
                      validatorErrorText: 'Enter Your Mobile',
                    ),
                    const SizedBox(height: 8),
                    GetBuilder<SignUpController>(
                      builder: (_) {
                        return CustomTextFormField(
                          controller: _passwordTEController,
                          hintText: 'Password',
                          icon: IconButton(
                            onPressed: signUpController.togglePasswordVisibility,
                            icon: signUpController.showPassword
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                          ),
                          validatorErrorText: 'Enter Your Password',
                          obscureText: signUpController.showPassword,
                        );
                      }
                    ),
                    const SizedBox(height: 16),
                    GetBuilder<SignUpController>(
                      builder: (_) {
                        return Visibility(
                          visible: !signUpController.registrationInProgress,
                          replacement: const Center(child: CircularProgressIndicator()),
                          child: ElevatedButton(
                            onPressed: _onTapSignUpButton,
                            child: const Icon(Icons.arrow_circle_right_outlined),
                          ),
                        );
                      }
                    ),
                    const SizedBox(height: 36),
                    Center(
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: AppColors.blackColor.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.4),
                            text: "Have account? ",
                            children: [
                              TextSpan(
                                  text: 'Sign in',
                                  style: const TextStyle(
                                      color: AppColors.themeColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _onTapSignInButton),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
        ),
      ),
    );
  }

  Future<void> _onTapSignUpButton () async {
    if(_formKey.currentState!.validate()){

      final bool result = await signUpController.registerUser(
        _emailTEController.text.trim(),
        _firstNameTEController.text.trim(),
        _lastNameTEController.text.trim(),
        _mobileNumberTEController.text.trim(),
        _passwordTEController.text,
      );
      if (result){
        Get.back();
        if(mounted){
          showSnackBarMessage(context, 'Registration Successful');
          _clearTextField();
        }
      } else {
        if(mounted){
          showSnackBarMessage(context, signUpController.errorMessage);
        }
      }
    }
  }




  void _onTapSignInButton() {
    Get.back();
  }

  void _clearTextField(){
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileNumberTEController.clear();
    _passwordTEController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileNumberTEController.dispose();
    _passwordTEController.dispose();
  }
}
