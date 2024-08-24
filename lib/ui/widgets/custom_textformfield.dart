import 'package:flutter/material.dart';
import '../utility/app_constants.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {super.key,
      required this.controller,
      this.keyBoardType = TextInputType.text,
      required this.hintText,
      this.maxLines,
      this.validator,
      this.icon,
      this.obscureText = false,
      this.validatorErrorText,
      this.regExpErrorText,
      this.isRegExpValidation = false,
      this.isEnabled = true,
        this.isValidate = true
      });

  final String hintText;
  final TextEditingController controller;
  final TextInputType keyBoardType;
  final int? maxLines;
  final String? Function(String?)? validator;
  final Widget? icon;
  final bool obscureText;
  final String? validatorErrorText;
  final String? regExpErrorText;
  final bool? isRegExpValidation;
  final bool? isEnabled;
  final bool? isValidate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyBoardType,
      enabled: isEnabled,
      decoration: InputDecoration(hintText: hintText, suffixIcon: icon),
      maxLines: maxLines ?? 1,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (!isValidate!) {
          return null;
        }
        if (validator != null) {
          final customValidationResult = validator!(value);
          if (customValidationResult != null) {
            return customValidationResult;
          }
        }
        if (value!.trim().isEmpty) {
          return validatorErrorText;
        }
        if (isRegExpValidation! && !AppConstants.emailRegExp.hasMatch(value)) {
          return regExpErrorText;
        }
        return null;
      },
      obscureText: obscureText == false ? false : obscureText,
    );
  }
}
