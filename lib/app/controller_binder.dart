import 'package:get/get.dart';
import 'package:task_manager_with_getx/ui/controller/add_new_task_controller.dart';
import 'package:task_manager_with_getx/ui/controller/cancelled_task_controller.dart';
import 'package:task_manager_with_getx/ui/controller/completed_task_controller.dart';
import 'package:task_manager_with_getx/ui/controller/email_verification_controller.dart';
import 'package:task_manager_with_getx/ui/controller/in_progress_task_controller.dart';
import 'package:task_manager_with_getx/ui/controller/new_task_controller.dart';
import 'package:task_manager_with_getx/ui/controller/pin_verification_controller.dart';
import 'package:task_manager_with_getx/ui/controller/reset_password_controller.dart';
import 'package:task_manager_with_getx/ui/controller/sign_in_controller.dart';
import 'package:task_manager_with_getx/ui/controller/sign_up_controller.dart';
import 'package:task_manager_with_getx/ui/controller/update_profile_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=> SignInController());
    Get.put(SignUpController());
    Get.put(EmailVerificationController());
    Get.put(PinVerificationController());
    Get.lazyPut(()=>UpdateProfileController());
    Get.lazyPut(()=> ResetPasswordController());
    Get.lazyPut(()=> NewTaskController());
    Get.lazyPut(()=> CompletedTaskController());
    Get.lazyPut(()=> CancelledTaskController());
    Get.lazyPut(()=> InProgressTaskController());
    Get.lazyPut(()=> AddNewTaskController());
  }
}