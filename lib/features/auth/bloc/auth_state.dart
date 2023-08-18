part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  String get name => '';
  String get avatar => '';

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
