import 'package:flutter/material.dart';
import 'app_colors.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.lightBackground,
  cardColor: AppColors.lightInputFill,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.appbarLight,
  ),
  focusColor: AppColors.messageLight,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.lightPrimaryText, fontSize: 18),
    bodyMedium: TextStyle(color: AppColors.lightPrimaryText, fontSize: 16),
    bodySmall: TextStyle(color: AppColors.lightSecondaryText, fontSize: 14),
    titleLarge: TextStyle(color: AppColors.lightPrimaryText, fontSize: 24),
    titleMedium: TextStyle(color: AppColors.lightPrimaryText, fontSize: 20),
    titleSmall: TextStyle(color: AppColors.lightPrimaryText, fontSize: 18),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary, // Button color
      foregroundColor: Colors.white, // Text color
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: AppColors.lightInputFill,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primary),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.error),
    ),
  ),
  dividerColor: AppColors.divider,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.darkBackground,
  canvasColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.appbarDark,
    foregroundColor: AppColors.darkPrimaryText,
  ),
  focusColor: AppColors.messageDark,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.darkPrimaryText, fontSize: 18),
    bodyMedium: TextStyle(color: AppColors.darkPrimaryText, fontSize: 16),
    bodySmall: TextStyle(color: AppColors.darkSecondaryText, fontSize: 14),
    titleLarge: TextStyle(color: AppColors.darkPrimaryText, fontSize: 24),
    titleMedium: TextStyle(color: AppColors.darkPrimaryText, fontSize: 20),
    titleSmall: TextStyle(color: AppColors.darkPrimaryText, fontSize: 18),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary, // Button color
      foregroundColor: Colors.white, // Text color
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkInputFill,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primary),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.error),
    ),
  ),
  dividerColor: AppColors.divider,
);
