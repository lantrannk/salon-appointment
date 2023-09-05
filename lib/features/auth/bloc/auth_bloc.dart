import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/constants.dart';
import '../../../core/validations/validations.dart';
import '../model/user.dart';
import '../repository/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.userRepo) : super(LoginInProgress()) {
    on<LoginEvent>(_handleLoginEvent);
    on<LogoutEvent>(_handleLogOutEvent);
    on<UserLoad>(_getUser);
  }

  final UserRepository userRepo;

  Future<void> _handleLoginEvent(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoginInProgress());
    try {
      final List<User> users = await userRepo.getUsers();
      if (FormValidation.isValidPassword(event.password) != null ||
          FormValidation.isValidPhoneNumber(event.phoneNumber) != null) {
        emit(const LoginFailure(ErrorMessage.invalidAccount));
        return;
      }
      if (FormValidation.isLoginSuccess(
          users, event.phoneNumber, event.password)) {
        final user = users
            .where((e) =>
                e.phoneNumber == event.phoneNumber &&
                e.password == event.password)
            .first;
        await userRepo.setUser(user);
        emit(LoginSuccess());
      } else {
        emit(const LoginFailure(ErrorMessage.incorrectAccount));
      }
    } on Exception catch (e) {
      emit(
        LoginFailure(e.toString()),
      );
    }
  }

  Future<void> _handleLogOutEvent(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(LogoutInProgress());
    await userRepo.clearStorage();
    emit(LogoutSuccess());
  }

  Future<void> _getUser(
    UserLoad event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await userRepo.getUser();

      emit(
        UserLoadSuccess(
          user!.name,
          user.avatar,
        ),
      );
    } on Exception catch (e) {
      emit(
        UserLoadFailure(
          error: e.toString(),
        ),
      );
    }
  }
}
