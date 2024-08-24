import 'dart:convert';
import 'package:flutter/material.dart';
import '../controller/auth_controller.dart';
import '../screens/auth/sign_in_screen.dart';
import '../screens/update_profile_screen.dart';
import '../utility/colors.dart';

AppBar profileAppBar(context, [bool fromUpdateProfileScreen = false]) {
  void _onTapProfileAppBar() {
    if (fromUpdateProfileScreen) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UpdateProfileScreen(),
      ),
    );
  }

  Future<void> _logOutConfirmationDialog() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text(
            'Are you sure for logout',
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Text('NO')),
            IconButton(
                onPressed: () async {
                  await AuthController.clearAllData();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
                      ),
                          (route) => false);
                },
                icon: const Text('YES')),
          ],
        );
      },
    );
  }

  return AppBar(
    backgroundColor: AppColors.themeColor,
    leading: Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: _onTapProfileAppBar,
        child: CircleAvatar(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.memory(
              base64Decode(
                AuthController.userData?.photo ?? "",
              ),
            ),
          ),
        ),
      ),
    ),
    title: GestureDetector(
      onTap: _onTapProfileAppBar,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AuthController.userData?.fullName ?? '',
            style: const TextStyle(fontSize: 16, color: AppColors.whiteColor),
          ),
          Text(
            AuthController.userData?.email ?? '',
            style: const TextStyle(
                fontSize: 12,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 12),
        child: IconButton(
            onPressed: () {
              _logOutConfirmationDialog();
            },
            icon: const Icon(Icons.logout_outlined)),
      )
    ],
  );

}
