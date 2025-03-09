import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final Box box;
  ThemeCubit(this.box) : super(_getInitialThemeMode(box));

  static ThemeMode _getInitialThemeMode(Box box) {
    String? savedTheme = box.get('themeMode', defaultValue: 'light');
    if (savedTheme == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }

  void setTheme(ThemeMode themeMode) {
    box.put('themeMode', themeMode == ThemeMode.dark ? 'dark' : 'light');
    emit(themeMode);
  }
}