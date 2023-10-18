import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/constants.dart';
import '../../../core/validations/validations.dart';
import '../repository/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.userRepo) : super(LoginInitial()) {
    on<LoginEvent>(_handleLoginEvent);
    on<LogoutEvent>(_handleLogOutEvent);
    on<UserLoad>(_getUser);
    on<LoginPhoneNumberChanged>(_changePhoneNumber);
    on<LoginPasswordChanged>(_changePassword);
  }

  final UserRepository userRepo;

  Future<void> _handleLoginEvent(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoginInProgress());
    try {
      if (event.phoneNumberErrorText != null ||
          event.passwordErrorText != null) {
        emit(const LoginFailure(ErrorMessage.invalidAccount));
        return;
      }

      final user = await userRepo.login(
        event.phoneNumber,
        event.password,
      );

      if (user != null) {
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

  void _changePhoneNumber(
    LoginPhoneNumberChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(LoginInformationBeforeChange());
    emit(
      LoginPhoneNumberOnChange(
        phoneNumber: event.phoneNumber,
        phoneNumberErrorText: FormValidation.isValidPhoneNumber(
          event.phoneNumber,
        ),
      ),
    );
  }

  void _changePassword(
    LoginPasswordChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(LoginInformationBeforeChange());
    emit(
      LoginPasswordOnChange(
        password: event.password,
        passwordErrorText: FormValidation.isValidPassword(
          event.password,
        ),
      ),
    );
  }
}
