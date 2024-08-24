import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_with_getx/ui/controller/reset_password_controller.dart';
import 'package:task_manager_with_getx/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager_with_getx/ui/utility/strings.dart';
import 'package:task_manager_with_getx/ui/widgets/background_widget.dart';
import 'package:task_manager_with_getx/ui/widgets/custom_progress_indicator.dart';
import '../../../data/models/network_response.dart';
import '../../../data/network_caller/network_caller.dart';
import '../../../data/utilities/api_urls.dart';
import '../../utility/colors.dart';
import '../../widgets/snack_bar_message.dart';
import '../../widgets/title_large_text_widget.dart';
import '../../widgets/custom_textformfield.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.email, required this.oTP});
  final String email;
  final String oTP;


  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ResetPasswordController resetPasswordController = Get.find<ResetPasswordController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  const TitleLargeText(titleLarge: resetPasswordScreenTitle),
                  const SizedBox(height: 6),
                  Text(
                    resetVerificationScreenSubTitle,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 16),
                  GetBuilder<ResetPasswordController>(
                    builder: (_) {
                      return CustomTextFormField(
                        controller: _passwordTEController,
                        hintText: 'New Password',
                        icon: IconButton(
                          onPressed: resetPasswordController.toggleNewPasswordVisibility,
                          icon: resetPasswordController.showNewPassword
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                        validatorErrorText: 'Enter New Password',
                        obscureText: resetPasswordController.showNewPassword,
                      );
                    }
                  ),
                  const SizedBox(height: 8),
                  GetBuilder<ResetPasswordController>(
                      builder: (_) {
                      return CustomTextFormField(
                        controller: _confirmPasswordTEController,
                        hintText: 'Confirm New Password',
                        icon: IconButton(
                          onPressed: resetPasswordController.toggleConfirmNewPasswordVisibility,
                          icon: resetPasswordController.showConfirmNewPassword
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                        validatorErrorText: 'Confirm New Password',
                        obscureText: resetPasswordController.showConfirmNewPassword,
                      );
                    }
                  ),
                  const SizedBox(height: 16),
                  GetBuilder<ResetPasswordController>(
                      builder: (_) {
                      return Visibility(
                        visible: !resetPasswordController.resetPasswordInProgress,
                        replacement: const CustomProgressIndicator(),
                        child: ElevatedButton(
                          onPressed: _onTapConfirmResetPassButton,
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      );
                    }
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: AppColors.blackColor.withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4),
                        text: "Don't have an account? ",
                        children: [
                          TextSpan(
                              text: 'Sign in',
                              style: const TextStyle(color: AppColors.themeColor),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _onTapSignInButton),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    Get.offAll(const SignInScreen());
   // Get.offUntil(const SignInScreen() as Route, (route) => false);
  }

  Future<void> _onTapConfirmResetPassButton() async {
    if(_formKey.currentState!.validate()){
      String password = _passwordTEController.text.trim();
      String confirmPassword = _confirmPasswordTEController.text.trim();
      if (password != confirmPassword) {
        showSnackBarMessage(context, 'Passwords do not match');
        return;
      }
      bool result = await resetPasswordController.onTapConfirmResetPassword(password, widget.email, widget.oTP);
    if(result){
      if (mounted) {
        showSnackBarMessage(context, 'Password reset successful!');
        Get.offAll(const SignInScreen());
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context, 'Password reset failed! Try again');
      }
    }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
  }
}
