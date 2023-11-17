
class Guard{
  static String? nullValue(String? value, String name){
    if(value == null){
      return '$name is null';
    }
    return null;
  }

  static String? emptyString(String? value, String name){
    final isNull = nullValue(value, name);
    if(isNull != null){
      return isNull;
    }
    if(value!.isEmpty){
      return '$name is empty';
    }
    return null;
  }

    static String? invalidEmail(String? value, name) {
  final isEmpty = emptyString(value, name);

  if (isEmpty != null) {
    return isEmpty;
  }

  // Regular expression for email validation
  final emailPattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*$';
  final regExp = RegExp(emailPattern);

  if (value == null || !regExp.hasMatch(value)) {
    return '$name is not a valid email address';
  }

  return null; // Email is valid
}

static String? validatePassword(String? value, String name) {
  if (value == null || value.isEmpty) {
    return '$name is required';
  }

  if (value.length < 8) {
    return '$name must be at least 8 characters long.';
  }

  final passwordPattern = RegExp(r'^(?=.*[A-Z])(?=.*\d)');
  if (!passwordPattern.hasMatch(value)) {
    return '$name must contain at least one capital letter and at least one number.';
  }
  return null; // Password is valid
}
    static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    } else if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateTitle(String? value, name) {
    if (value == null || value.isEmpty) {
      return 'Please enter a $name';
    }
    return null;
  }

  static String? validateDescription(String? value, name) {
    if (value == null || value.isEmpty) {
      return 'Please enter a $name';
    }
    return null;
  }
  
}