import '../../features/auth/model/user.dart';
import '../constants/constants.dart';

class FormValidation {
  static String? isValidPhoneNumber(String? phoneNumber) {
    final RegExp phoneNumberRegExp = RegExp(phoneNumberRegExpPattern);

    if (phoneNumber!.isEmpty) {
      return 'Phone number is blank.';
    } else if (!phoneNumberRegExp.hasMatch(phoneNumber)) {
      return 'Invalid phone number.';
    }
    return null;
  }

  static String? isValidPassword(String? password) {
    final RegExp passwordRegExp = RegExp(passwordRegExpPattern);

    if (password!.isEmpty) {
      return 'Password is blank.';
    } else if (!passwordRegExp.hasMatch(password)) {
      return 'Invalid password.';
    }
    return null;
  }

  static bool isLoginSuccess(
    List<User> users,
    String? phoneNumber,
    String? password,
  ) {
    return users.any(
      (e) => e.phoneNumber == phoneNumber && e.password == password,
    );
  }
}
