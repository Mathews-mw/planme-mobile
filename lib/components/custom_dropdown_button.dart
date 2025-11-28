import 'package:flutter/material.dart';
import 'package:planme/theme/app_colors.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>>? items;
  final T? value;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final String? initialValue;
  final TextInputAction? textInputAction;
  final void Function(T?)? onChanged;
  final void Function(String?)? onSaved;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final bool? enabled;
  final int? minLines;
  final int? maxLines;

  const CustomDropdownButton({
    super.key,
    required this.items,
    this.value,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.initialValue,
    this.textInputAction,
    this.onChanged,
    this.onSaved,
    this.onFieldSubmitted,
    this.validator,
    this.enabled = true,
    this.minLines = 1,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    // final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final isDarkMode = false;

    return DropdownButtonFormField<T>(
      isExpanded: true,
      initialValue: value,
      items: items,
      onChanged: onChanged,
      dropdownColor: AppColors.lightBackground,
      style: TextStyle(
        color: isDarkMode ? AppColors.gray200 : AppColors.gray800,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(top: 10, left: 20),
        filled: true,
        fillColor: isDarkMode ? AppColors.gray900 : AppColors.gray100,
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14, color: AppColors.gray400),
        errorStyle: TextStyle(fontSize: 12, color: AppColors.dangerBase),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.gray700 : AppColors.purpleLight,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.gray700 : AppColors.purpleLight,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.purpleBase, width: 1),
        ),
      ),
    );
  }
}
