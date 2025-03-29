import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow/core/resources/dimensions.dart';

class ChangePasswordButton extends StatelessWidget {
  const ChangePasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: (){
        context.push('/changePassword');
      },
      child: Container(
        height: deviceHeight * 0.07,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
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
              Text('Change Password', style: Theme.of(context).textTheme.titleMedium!),
            ],
          ),
        ),
      ),
    );
  }
}