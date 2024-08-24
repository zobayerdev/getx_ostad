import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_with_getx/ui/controller/sign_in_controller.dart';
import 'package:task_manager_with_getx/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_manager_with_getx/ui/widgets/custom_progress_indicator.dart';
import 'package:task_manager_with_getx/ui/widgets/snack_bar_message.dart';
import '../../utility/colors.dart';
import '../../utility/strings.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/title_large_text_widget.dart';
import '../../widgets/custom_textformfield.dart';
import 'email_verification_screen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignInController signInController = Get.find<SignInController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                const TitleLargeText(titleLarge: signInScreenTitle),
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
                GetBuilder<SignInController>(
                  builder: (_) {
                    return CustomTextFormField(
                      controller: _passwordTEController,
                      hintText: 'Password',
                      icon: IconButton(
                        onPressed: signInController.togglePasswordVisibility,
                        icon: signInController.showPassword
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                      ),
                      validatorErrorText: 'Enter Your Password',
                      obscureText: signInController.showPassword,
                    );
                  }
                ),
                const SizedBox(height: 16),
                GetBuilder<SignInController>(
                  builder: (_) {
                    return Visibility(
                      visible: !signInController.signInApiInProgress,
                      replacement: const Center(child: CustomProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: _onTapSignInButton,
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    );
                  }
                ),
                const SizedBox(height: 35),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: _onTapForgotPasswordButton,
                        child: const Text('Forgot password'),
                      ),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: AppColors.blackColor.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.4),
                            text: "Don't have an account? ",
                            children: [
                              TextSpan(
                                  text: 'Sign up',
                                  style: const TextStyle(
                                      color: AppColors.themeColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _onTapSignUpButton),
                            ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Future<void> _onTapSignInButton() async {
    if (_formKey.currentState!.validate()) {

     final bool result = await signInController.signIn(_emailTEController.text.trim(), _passwordTEController.text.trim());
     if (result){
        Get.offAll(()=>const MainBottomNavScreen());
     } else {
       if(mounted){
         showSnackBarMessage(context, signInController.errorMessage);
       }
     }
    }
  }


  void _onTapForgotPasswordButton() {
    Get.to(() => const EmailVerificationScreen());
  }

  void _onTapSignUpButton() {
    Get.to(() => const SignUpScreen());
  }

  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
  }
}
