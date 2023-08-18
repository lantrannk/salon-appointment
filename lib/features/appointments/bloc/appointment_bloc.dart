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
    on<AppointmentRemoved>(_removeAppointment);
    on<AppointmentAdded>(_addAppointment);
    on<AppointmentEdited>(_editAppointment);
    on<UserLoad>(_getUser);
  }

  final http.Client client;

  late AppointmentApi appointmentApi;

  Future<void> _getAppointmentList(
    AppointmentLoad event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(AppointmentLoadInProgress());
      final List<Appointment> appointments = await AppointmentRepository.load();
      final List<User> users = await UserStorage.getUsers();
      emit(
        AppointmentLoadSuccess(
          users: users,
          appointments: appointments,
        ),
      );
    } on Exception catch (e) {
      emit(AppointmentLoadFailure(error: e.toString()));
    }
  }

  Future<void> _addAppointment(
    AppointmentAdded event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      appointmentApi = AppointmentApi(client);
      emit(AppointmentAddInProgress());
      await appointmentApi.addAppointment(event.appointment);
      emit(AppointmentAddSuccess());
    } on Exception catch (e) {
      emit(AppointmentAddFailure(error: e.toString()));
    }
  }

  Future<void> _editAppointment(
    AppointmentEdited event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      appointmentApi = AppointmentApi(client);
      emit(AppointmentAddInProgress());
      await appointmentApi.updateAppointment(event.appointment);
      emit(AppointmentEditSuccess());
    } on Exception catch (e) {
      emit(AppointmentAddFailure(error: e.toString()));
    }
  }

  Future<void> _removeAppointment(
    AppointmentRemoved event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      appointmentApi = AppointmentApi(client);
      emit(AppointmentRemoveInProgress());
      await appointmentApi.deleteAppointment(event.appointmentId);
      emit(AppointmentRemoveSuccess());
    } on Exception catch (e) {
      emit(AppointmentRemoveFailure(error: e.toString()));
    }
  }

  Future<void> _getUser(
    UserLoad event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      final user = await UserStorage.getUser();
      emit(UserLoadSuccess(user!));
    } on Exception catch (e) {
      emit(UserLoadFailure(error: e.toString()));
    }
  }
}
