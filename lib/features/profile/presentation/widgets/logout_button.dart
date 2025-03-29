import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:taskflow/core/resources/app_colors.dart';
import 'package:taskflow/core/resources/dimensions.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: (){
        Hive.box('SETTINGS').clear();
        context.go('/login');
      },
      child: Container(
        height: deviceHeight * 0.07,
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).textTheme.bodySmall!.color!,
              spreadRadius: 0.2,
              offset: const Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Text('Log out', style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: AppColors.white
              )),
              Spacer(),
              Icon(Icons.logout,color: AppColors.white,)
            ],
          ),
        ),
      ),
    );
  }
}