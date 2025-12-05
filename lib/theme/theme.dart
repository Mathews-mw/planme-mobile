import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planme/theme/app_colors.dart';

final ThemeData theme = ThemeData();

final ThemeData lightTheme = theme.copyWith(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
  textTheme: GoogleFonts.latoTextTheme(),
  snackBarTheme: theme.snackBarTheme.copyWith(
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppColors.purpleBase,
    actionTextColor: Colors.white,
    contentTextStyle: TextStyle(color: Colors.white),
  ),
  datePickerTheme: DatePickerThemeData(
    backgroundColor: AppColors.lightBackground,
    headerBackgroundColor: AppColors.purpleBase,
    headerForegroundColor: AppColors.lightBackground,
    dayForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white;
      }
      return AppColors.gray800;
    }),
    dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.purpleBase;
      }
      if (states.contains(WidgetState.hovered)) {
        return AppColors.purpleLight.withValues(alpha: 0.2);
      }
      return Colors.transparent;
    }),
    rangePickerBackgroundColor: AppColors.lightBackground,
  ),
);
