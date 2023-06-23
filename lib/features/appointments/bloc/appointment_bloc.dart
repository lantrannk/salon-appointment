import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/storage/user_storage.dart';
import '../../auth/model/user.dart';
import '../api/appointment_api.dart';
import '../model/appointment.dart';
import '../repository/appointment_repository.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  AppointmentBloc() : super(AppointmentInitial()) {
    on<AppointmentLoad>(_getAppointmentList);
    on<AppointmentRemovePressed>(_removeAppointment);
    on<AppointmentEdit>(_editAppointment);
    on<AppointmentAdd>(_addAppointment);
    on<UserLoad>(_getUser);
  }

  Future<void> _getAppointmentList(
    AppointmentLoad event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(AppointmentLoading());
      final List<Appointment> appointments =
          await AppointmentRepository.load(event.date);
      final List<User> users = await UserStorage.getUsers();
      emit(
        AppointmentLoadSuccess(
          users: users,
          appointments: appointments,
        ),
      );
    } on Exception catch (e) {
      emit(AppointmentLoadError(error: e.toString()));
    }
  }

  Future<void> _addAppointment(
    AppointmentAdd event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(AppointmentAdding());
      await AppointmentApi.addAppointment(event.appointment);
      emit(AppointmentAdded());
    } on Exception catch (e) {
      emit(AppointmentAddError(error: e.toString()));
    }
  }

  Future<void> _editAppointment(
    AppointmentEdit event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(AppointmentEditing());
      await AppointmentApi.updateAppointment(event.appointment);
      emit(AppointmentEdited());
    } on Exception catch (e) {
      emit(AppointmentEditError(error: e.toString()));
    }
  }

  Future<void> _removeAppointment(
    AppointmentRemovePressed event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(AppointmentRemoving());
      await AppointmentApi.deleteAppointment(event.appointmentId);
      emit(AppointmentRemoved());
    } on Exception catch (e) {
      emit(AppointmentRemoveError(error: e.toString()));
    }
  }

  Future<void> _getUser(
    UserLoad event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      final user = await UserStorage.getUser();
      emit(UserLoaded(User.fromJson(user)));
    } on Exception catch (e) {
      emit(UserLoadError(error: e.toString()));
    }
  }
}
