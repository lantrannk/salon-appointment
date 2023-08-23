import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/storage/user_storage.dart';
import '../../../core/utils.dart';
import '../../auth/model/user.dart';
import '../api/appointment_api.dart';
import '../model/appointment.dart';
import '../repository/appointment_repository.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  AppointmentBloc(
    this.appointmentApi,
    this.appointmentRepository,
    this.userStorage,
  ) : super(AppointmentInitial()) {
    on<AppointmentLoad>(_getAppointmentList);
    on<AppointmentRemoved>(_removeAppointment);
    on<AppointmentAdded>(_addAppointment);
    on<AppointmentEdited>(_editAppointment);
    on<AppointmentDateTimeChanged>(_changeDateTime);
    on<UserLoad>(_getUser);
  }

  final AppointmentApi appointmentApi;
  final AppointmentRepository appointmentRepository;
  final UserStorage userStorage;

  Future<void> _getAppointmentList(
    AppointmentLoad event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(AppointmentLoadInProgress());
      final List<Appointment> appointments = await appointmentRepository.load();
      final List<User> users = await userStorage.getUsers();

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
      final user = await userStorage.getUser();
      emit(UserLoadSuccess(user!));
    } on Exception catch (e) {
      emit(UserLoadFailure(error: e.toString()));
    }
  }

  void _changeDateTime(
    AppointmentDateTimeChanged event,
    Emitter<AppointmentState> emit,
  ) {
    final date = event.dateTime;
    final startTime = setDateTime(
      date,
      event.startTime,
    );
    final endTime = setDateTime(
      date,
      event.endTime,
    );

    if (isBeforeNow(startTime) || isBeforeNow(endTime)) {
      emit(
        const AppointmentDateTimeChangeFailure(
          error: 'before-now',
        ),
      );
    } else if (!isAfterStartTime(startTime, endTime)) {
      emit(
        const AppointmentDateTimeChangeFailure(
          error: 'different-time',
        ),
      );
    } else if (isBreakTime(startTime) || isBreakTime(endTime)) {
      emit(
        const AppointmentDateTimeChangeFailure(
          error: 'break-conflict',
        ),
      );
    } else if (isClosedTime(startTime) || isClosedTime(endTime)) {
      emit(
        const AppointmentDateTimeChangeFailure(
          error: 'closed-conflict',
        ),
      );
    } else {
      emit(AppointmentDateTimeChangeSuccess(
        date: date,
        startTime: startTime,
        endTime: endTime,
      ));
    }
  }
}
