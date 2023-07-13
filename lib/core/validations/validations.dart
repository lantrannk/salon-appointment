import '../../features/auth/model/user.dart';

class FormValidation {
  static String? isValidPhoneNumber(String? phoneNumber) {
    if (phoneNumber == '') {
      return 'Phone number is blank.';
    } else if (phoneNumber!.length != 10) {
      return 'Phone number must have 10 digits.';
    } else if (int.tryParse(phoneNumber) == null) {
      return 'Phone number must be a string of digits.';
    }
    return null;
  }

  static String? isValidPassword(String? password) {
    if (password == '') {
      return 'Password is blank.';
    } else if (password!.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  static bool isLoginSuccess(
      List<User> users, String? phoneNumber, String? password) {
    return users
        .any((e) => e.phoneNumber == phoneNumber && e.password == password);
  }
}
