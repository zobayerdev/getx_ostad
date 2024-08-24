import 'package:flutter/material.dart';

class TitleLargeText extends StatelessWidget {
  const TitleLargeText({super.key, required this.titleLarge});
  final String titleLarge;

  @override
  Widget build(BuildContext context) {
    return Text(titleLarge,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}