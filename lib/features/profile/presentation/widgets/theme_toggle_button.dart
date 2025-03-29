
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/core/common/cubit/theme_cubit/theme_cubit.dart';
import 'package:taskflow/core/resources/app_colors.dart';

import '../../../../core/resources/dimensions.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Text('Dark Mode', style: Theme.of(context).textTheme.titleMedium!),
            const Spacer(),
            const ThemeSwitch(),
          ],
        ),
      ),
    );
  }
}

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        bool isDarkMode = themeMode == ThemeMode.dark;
        return Switch.adaptive(
          value: isDarkMode,
          onChanged: (value) {
            context
                .read<ThemeCubit>()
                .setTheme(value ? ThemeMode.dark : ThemeMode.light);
          },
          activeColor: AppColors.green,
          inactiveThumbColor: AppColors.black,
          inactiveTrackColor: AppColors.white,
        );
      },
    );
  }
}