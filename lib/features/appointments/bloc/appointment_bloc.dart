import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/common.dart';
import '../../auth/model/user.dart';
import '../../auth/repository/user_repository.dart';
import '../api/appointment_api.dart';
import '../model/appointment.dart';
import '../repository/appointment_repository.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  AppointmentBloc({
    required this.appointmentApi,
    required this.appointmentRepository,
    required this.userRepository,
  }) : super(AppointmentInitial()) {
    on<AppointmentLoad>(_getAppointmentList);
    on<AppointmentRemoved>(_removeAppointment);
    on<AppointmentAdded>(_addAppointment);
    on<AppointmentEdited>(_editAppointment);
    on<AppointmentDateTimeChanged>(_changeDateTime);
  }

  final AppointmentApi appointmentApi;
  final AppointmentRepository appointmentRepository;
  final UserRepository userRepository;

  Future<void> _getAppointmentList(
    AppointmentLoad event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(AppointmentLoadInProgress());

      final List<User> users = await userRepository.getUsers();
      final User? user = await userRepository.getUser();
      final List<Appointment> appointments =
          await appointmentRepository.loadAllAppointments(user!);

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

  void _changeDateTime(
    AppointmentDateTimeChanged event,
    Emitter<AppointmentState> emit,
  ) {
    final date = event.date;
    final startTime = setDateTime(
      date,
      event.startTime,
    );
    final endTime = setDateTime(
      date,
      event.endTime,
    );

    emit(const AppointmentDateTimeBeforeChange(error: ''));

    if (isBeforeNow(startTime) || isBeforeNow(endTime)) {
      emit(
        const AppointmentDateTimeChangeFailure(
          error: ErrorMessage.beforeNow,
        ),
      );
    } else if (!isAfterStartTime(startTime, endTime)) {
      emit(
        const AppointmentDateTimeChangeFailure(
          error: ErrorMessage.differentTime,
        ),
      );
    } else if (isBreakTime(startTime) || isBreakTime(endTime)) {
      emit(
        const AppointmentDateTimeChangeFailure(
          error: ErrorMessage.breakConflict,
        ),
      );
    } else if (isClosedTime(startTime) || isClosedTime(endTime)) {
      emit(
        const AppointmentDateTimeChangeFailure(
          error: ErrorMessage.closedConflict,
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
