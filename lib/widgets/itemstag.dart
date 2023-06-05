import 'package:flutter/material.dart';

import '../theme/app-theme.dart';
import '../theme/colors.dart';
class MyTag extends StatelessWidget {
  final bool flag;
  final String name;
  const MyTag({Key? key, required this.flag, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: AppColors.white,
      side: const BorderSide(color: AppColors.grey),
      avatar: flag
          ? const CircleAvatar(
          backgroundColor: AppColors.orange,
          child: Text(
            'OUT',
            style: TextStyle(
                color: Colors.white, fontSize: 11),
          ))
          : const CircleAvatar(
          backgroundColor: AppColors.green,
          child: Text(
            'IN',
            style: TextStyle(
                color: Colors.white, fontSize: 16),
          )),
      label: Text(
        name,
        style: textTheme.bodyMedium,
      ),
    );
  }
}
