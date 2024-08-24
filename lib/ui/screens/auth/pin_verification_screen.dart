import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_with_getx/ui/controller/pin_verification_controller.dart';
import 'package:task_manager_with_getx/ui/screens/auth/reset_password_screen.dart';
import '../../utility/colors.dart';
import '../../utility/strings.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/custom_progress_indicator.dart';
import '../../widgets/snack_bar_message.dart';
import '../../widgets/title_large_text_widget.dart';
import 'sign_in_screen.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key, required this.email});

  final String email;

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _pinTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  final PinVerificationController pinVerificationController = Get.find<PinVerificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              const TitleLargeText(titleLarge: pinVerificationScreenTitle),
              const SizedBox(height: 6),
              Text(pinVerificationScreenSubTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 16),
                PinCodeTextField(
                  length: 6,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedColor: AppColors.themeColor,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  keyboardType: TextInputType.number,
                  enableActiveFill: true,
                  controller: _pinTEController,
                  appContext: context,
                ),
              const SizedBox(height: 16),
              GetBuilder<PinVerificationController>(
                builder: (_) {
                  return Visibility(
                    visible: !pinVerificationController.pinVrificationInprogress,
                    replacement: const CustomProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapVarifyButton,
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
                      text: "Have account? ",
                      children: [
                        TextSpan(
                            text: 'Sign in',
                            style: const TextStyle(color: AppColors.themeColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _onTapSignInButton),
                      ]),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  void _onTapSignInButton() {
    Get.offAll(const SignInScreen());
    // Get.offUntil(
    //   GetPageRoute(page: () => const SignInScreen()),
    //       (route) => false,
    // );
  }

  Future<void> _onTapVarifyButton() async {
    final String recoveryEmail = widget.email;
    String oTP = _pinTEController.text.trim();

    bool result = await pinVerificationController.onTapPinVarify(recoveryEmail, oTP);

    if(result){
      if (mounted) {
        showSnackBarMessage(
          context,
          'Pin verification Successful!',
        );
        Get.to(ResetPasswordScreen(email: recoveryEmail, oTP: oTP));
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
          context, pinVerificationController.errorMessage,
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pinTEController.dispose();
  }
}
