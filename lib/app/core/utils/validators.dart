class Validators {
  static String? required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;

  static String? name(String? value, {bool isLastName = false}) {
    if (value == null || value.trim().isEmpty) {
      return isLastName ? 'Last name is required' : 'First name is required';
    }
    if (value.trim().length < 2) return 'At least 2 characters';
    if (!RegExp(r'^[A-Z]').hasMatch(value.trim())) {
      return isLastName
          ? 'Last letter\nmust be capitalized'
          : 'First letter\nmust be capitalized';
    }
    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value.trim())) {
      return 'Only letters allowed';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter your email';
    if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? syrianMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }
    if (!RegExp(r"^(?:\+963|0)?9\d{8}$").hasMatch(value.trim())) {
      return 'Must be a valid Syrian mobile (e.g., 09xxxxxxxx)';
    }
    return null;
  }

  static String? emailOrSyrianMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email or Mobile is required';
    }
    if (RegExp(r'[a-zA-Z]').hasMatch(value)) return email(value);
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

  static String? birthdate(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    if (!RegExp(r"^\d{4}-\d{2}-\d{2}$").hasMatch(value.trim())) {
      return 'Format: YYYY-MM-DD';
    }
    final parsedDate = DateTime.tryParse(value.trim());
    if (parsedDate == null) return 'Invalid date';
    if (parsedDate.isAfter(DateTime.now())) return 'Future dates\nnot allowed';
    return null;
  }
}
