part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];

  String get phoneNumber => '';

  String get password => '';
}

class LoginEvent extends AuthEvent {
  const LoginEvent({
    required this.phoneNumber,
    required this.password,
  });

  @override
  final String phoneNumber;

  @override
  final String password;
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
