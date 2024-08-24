import 'package:flutter/material.dart';
import '../utility/colors.dart';
import '../widgets/profile_app_bar.dart';
import 'cancelled_task_screen.dart';
import 'completed_task_screen.dart';
import 'in_progress_task_screen.dart';
import 'new_task_screen.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screenList = const [
    NewTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),
    InProgressTaskScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: _screenList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _selectedIndex = index;
          if (mounted) {
            setState(() {});
          }
        },
        selectedItemColor: AppColors.themeColor,
        unselectedItemColor: AppColors.grayColor,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.sticky_note_2_outlined), label: 'New Task'),
          BottomNavigationBarItem(
              icon: Icon(Icons.done_all_outlined), label: 'Completed'),
          BottomNavigationBarItem(
              icon: Icon(Icons.speaker_notes_off_outlined), label: 'Canceled'),
          BottomNavigationBarItem(
              icon: Icon(Icons.cached_sharp), label: 'Progress'),
        ],
      ),
    );
  }
}
