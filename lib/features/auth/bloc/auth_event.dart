part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];

  String get phoneNumber => '';

  String get password => '';

  String? get phoneNumberErrorText => null;

  String? get passwordErrorText => null;
}

class LoginEvent extends AuthEvent {
  const LoginEvent({
    required this.phoneNumber,
    required this.password,
    this.phoneNumberErrorText,
    this.passwordErrorText,
  });

  @override
  final String phoneNumber;

  @override
  final String password;

  @override
  final String? phoneNumberErrorText;

  @override
  final String? passwordErrorText;
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class UserLoad extends AuthEvent {
  const UserLoad();
}

class LoginPhoneNumberChanged extends AuthEvent {
  const LoginPhoneNumberChanged({
    required this.phoneNumber,
  });

  @override
  final String phoneNumber;
}

class LoginPasswordChanged extends AuthEvent {
  const LoginPasswordChanged({
    required this.password,
  });

  @override
  final String password;
}
