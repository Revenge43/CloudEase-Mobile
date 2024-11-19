import 'package:cloudease/core/constants/colors.dart';
import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onTap;
  const MyDrawerTile(
      {super.key, required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(color: AppColors.primaryColor),
      ),
      leading: Icon(
        icon,
        color: AppColors.primaryColor,
        size: 23,
      ),
    );
  }
}