import '../constants/constants.dart';
import '../generated/l10n.dart';

String loginError(
  S l10n,
  String errorMessage,
) {
  switch (errorMessage) {
    case ErrorMessage.invalidAccount:
      return l10n.invalidAccountError;
    case ErrorMessage.incorrectAccount:
      return l10n.incorrectAccountError;
    default:
      return errorMessage;
  }
}
