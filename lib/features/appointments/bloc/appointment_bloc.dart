import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../core/storage/user_storage.dart';
import '../../auth/model/user.dart';
import '../api/appointment_api.dart';
import '../model/appointment.dart';
import '../repository/appointment_repository.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  AppointmentBloc(this.client) : super(AppointmentInitial()) {
    on<AppointmentLoad>(_getAppointmentList);
    on<AppointmentRemovePressed>(_removeAppointment);
    on<AppointmentAdd>(_addAppointment);
    on<AppointmentEdit>(_editAppointment);
    on<UserLoad>(_getUser);
  }

  final http.Client client;

  late AppointmentApi appointmentApi;

  Future<void> _getAppointmentList(
    AppointmentLoad event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(AppointmentLoading());
      final List<Appointment> appointments = await AppointmentRepository.load();
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
      appointmentApi = AppointmentApi(client);
      emit(AppointmentAdding());
      await appointmentApi.addAppointment(event.appointment);
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
      appointmentApi = AppointmentApi(client);
      emit(AppointmentAdding());
      await appointmentApi.updateAppointment(event.appointment);
      emit(AppointmentEdited());
    } on Exception catch (e) {
      emit(AppointmentAddError(error: e.toString()));
    }
  }

  Future<void> _removeAppointment(
    AppointmentRemovePressed event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      appointmentApi = AppointmentApi(client);
      emit(AppointmentRemoving());
      await appointmentApi.deleteAppointment(event.appointmentId);
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
      emit(UserLoaded(user!));
    } on Exception catch (e) {
      emit(UserLoadError(error: e.toString()));
    }
  }
}
