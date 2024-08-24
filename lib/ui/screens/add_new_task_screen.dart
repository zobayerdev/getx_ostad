import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_with_getx/ui/controller/add_new_task_controller.dart';
import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/api_urls.dart';
import '../utility/strings.dart';
import '../widgets/background_widget.dart';
import '../widgets/custom_progress_indicator.dart';
import '../widgets/custom_textformfield.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/title_large_text_widget.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key, required this.onTaskAdded});
  final VoidCallback onTaskAdded;

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _subjectTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AddNewTaskController addNewTaskController = Get.find<AddNewTaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: BackgroundWidget(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 35),
                  const TitleLargeText(titleLarge: addNewTaskScreenTitle),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    controller: _subjectTEController,
                    hintText: 'Subject',
                    validatorErrorText: 'Please Enter Your Subject',
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: _descriptionTEController,
                    hintText: 'Description',
                    maxLines: 5,
                    validatorErrorText: 'Please Enter Your Description',
                  ),
                  const SizedBox(height: 16),
                  GetBuilder(
                    builder: (_) {
                      return Visibility(
                        visible: !addNewTaskController.addNewTaskInProgress,
                        replacement: const CustomProgressIndicator(),
                        child: ElevatedButton(
                          onPressed: _onTapAddNewTaskButton,
                          child: const Icon(
                            Icons.arrow_circle_right_outlined,
                          ),
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onTapAddNewTaskButton() async {
    if(_formKey.currentState!.validate()){
      bool result = await addNewTaskController.addNewTask(_subjectTEController.text.trim(), _descriptionTEController.text.trim());
      if(result){
        _clearTextField();
        if (mounted) {
          showSnackBarMessage(context, 'New Task Added');
          Get.back();
          widget.onTaskAdded();
        }
      } else {
        if (mounted) {
          showSnackBarMessage(context, addNewTaskController.errorMessage, true);
        }
      }
    }
  }

  void _clearTextField() {
    _subjectTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _subjectTEController.dispose();
    _descriptionTEController.dispose();
  }
}