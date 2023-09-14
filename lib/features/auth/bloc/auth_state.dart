part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  String get name => '';
  String get avatar => '';
  String get phoneNumber => '';
  String get password => '';
  String? get phoneNumberErrorText => null;
  String? get passwordErrorText => null;

  @override
  List<Object> get props => [];
}

class LoginInProgress extends AuthState {}

class LoginFailure extends AuthState {
  const LoginFailure(this.error);

  final String error;
}

class LoginSuccess extends AuthState {}

class LogoutInProgress extends AuthState {}

class LogoutSuccess extends AuthState {}

class UserLoadSuccess extends AuthState {
  const UserLoadSuccess(this.name, this.avatar);

  @override
  final String name;

  @override
  final String avatar;
}

class UserLoadFailure extends AuthState {
  const UserLoadFailure({this.error});

  final String? error;
}

class LoginInformationBeforeChange extends AuthState {}

class LoginPhoneNumberOnChange extends AuthState {
  const LoginPhoneNumberOnChange({
    required this.phoneNumber,
    this.phoneNumberErrorText,
  });

  @override
  final String phoneNumber;

  @override
  final String? phoneNumberErrorText;
}

class LoginPasswordOnChange extends AuthState {
  const LoginPasswordOnChange({
    required this.password,
    this.passwordErrorText,
  });

  @override
  final String password;

  @override
  final String? passwordErrorText;
}
