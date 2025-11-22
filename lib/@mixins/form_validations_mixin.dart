mixin FormValidationsMixin {
  String? isNotEmpty(String? value, [String? message]) {
    if (value!.isEmpty) {
      return message ?? 'Required field. Please, fill it in.';
    }

    return null;
  }

  String? combine(List<String? Function()> validators) {
    for (final func in validators) {
      final validation = func();

      if (validation != null) return validation;
    }

    return null;
  }

  String? isEmail(String? value, [String? message]) {
    if (value!.isNotEmpty) {
      if (value.contains('@')) {
        return null;
      } else {
        return message ?? 'Please, provide a valid e-mail.';
      }
    }

    return null;
  }
}
