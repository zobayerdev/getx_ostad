import 'package:flutter/material.dart';
import '../utility/colors.dart';

void showSnackBarMessage(
    BuildContext context,
    String message, [
      bool isError = false,
    ]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : AppColors.blackColor.withOpacity(0.5),
    ),
  );
}