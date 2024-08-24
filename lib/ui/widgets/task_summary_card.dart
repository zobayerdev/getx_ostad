import 'package:flutter/material.dart';
import '../utility/colors.dart';

class TaskSummaryCard extends StatelessWidget {
  const TaskSummaryCard({
    super.key, required this.title, required this.count,
  });

  final String title;
  final String count;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 135),
      child: Card(
        elevation: 3,
        color: AppColors.whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(count, style: Theme.of(context).textTheme.titleLarge),
              Text(title, style: Theme.of(context).textTheme.titleSmall),

            ],
          ),
        ),
      ),
    );
  }
}
