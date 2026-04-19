class Validators {
  static String? required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    if (!RegExp(r'^[A-Z]').hasMatch(value.trim())) {
      return 'First letter\nmust be capitalized';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  static String? syrianMobile(String? value) {
    if (value == null || value.trim().isEmpty) return 'Mobile is required';
    if (!RegExp(r"^(?:\+963|0)?9\d{8}$").hasMatch(value.trim())) {
      return 'Must be a valid Syrian mobile (e.g., 09xxxxxxxx)';
    }
    return null;
  }

  static String? emailOrSyrianMobile(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Email or Mobile is required';
    if (value.contains('@')) return email(value);
    return syrianMobile(value);
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    if (!value.contains(RegExp(r'[A-Z]')))
      return 'Must contain at least 1 uppercase letter';
    return null;
  }

  static String? confirmPassword(String? value, String? password) {
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static String? age(String? value) {
    if (value == null || value.trim().isEmpty) return 'Age is required';
    final ageInt = int.tryParse(value);
    if (ageInt == null || ageInt < 18 || ageInt > 90) {
      return 'Valid numeric age (18-90)';
    }
    return null;
  }
}
