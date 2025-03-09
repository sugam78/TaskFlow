import 'package:flutter/material.dart';
import 'package:taskflow/core/resources/app_colors.dart';

enum SnackBarType { success, error }

class CustomSnackBar {
  static void show(
      BuildContext context, {
        required String message,
        required SnackBarType type,
        Duration duration = const Duration(seconds: 3),
      }) {
    final Color backgroundColor = type == SnackBarType.success
        ? AppColors.snackBarSuccess
        : AppColors.snackBarError;

    final IconData icon = type == SnackBarType.success
        ? Icons.check_circle
        : Icons.error;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: AppColors.lightInputFill),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.lightInputFill,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: duration,
      ),
    );
  }
}