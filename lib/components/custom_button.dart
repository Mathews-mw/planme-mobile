import 'package:flutter/material.dart';
import 'package:planme/theme/app_colors.dart';

enum Variant {
  primary,
  muted,
  success,
  danger;

  Color get color {
    switch (this) {
      case Variant.primary:
        return AppColors.purpleBase;
      case Variant.muted:
        return AppColors.gray200;
      case Variant.success:
        return AppColors.successBase;
      case Variant.danger:
        return AppColors.dangerBase;
    }
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final Variant? variant;
  final Widget? icon;
  final bool isLoading;
  final bool disabled;
  final bool outline;
  final IconAlignment? iconAlignment;
  final void Function() onPressed;

  const CustomButton({
    super.key,
    required this.label,
    this.variant = Variant.primary,
    this.icon,
    this.isLoading = false,
    this.disabled = false,
    this.outline = false,
    this.iconAlignment,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        disabledBackgroundColor: Color.fromRGBO(106, 70, 235, 0.4),
        disabledForegroundColor: AppColors.gray400,
        backgroundColor: variant != null
            ? variant!.color
            : AppColors.purpleBase,
        foregroundColor: variant == Variant.muted
            ? AppColors.purpleBase
            : AppColors.foreground,
        shape: variant == Variant.muted
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(99)),
                side: BorderSide(color: AppColors.gray300),
              )
            : null,
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      label: Text(isLoading ? 'Carregando...' : label),
      icon: isLoading
          ? CircularProgressIndicator(
              backgroundColor: AppColors.purpleBase,
              constraints: BoxConstraints(minHeight: 22, minWidth: 22),
            )
          : icon,
      iconAlignment: iconAlignment,
      onPressed: isLoading || disabled ? null : onPressed,
    );
  }
}
