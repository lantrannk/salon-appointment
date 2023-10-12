import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/utils/common.dart';
import '../../../../auth/model/user.dart';
import '../../../../auth/repository/user_repository.dart';
import '../../../model/appointment.dart';
import '../../../repository/appointment_repository.dart';

part 'appointment_form_event.dart';
part 'appointment_form_state.dart';

class AppointmentFormBloc
    extends Bloc<AppointmentFormEvent, AppointmentFormState> {
  AppointmentFormBloc({
    required this.appointmentRepository,
    required this.userRepository,
  }) : super(
          AppointmentFormState(
            date: DateTime.now(),
            startTime: DateTime.now(),
            endTime: DateTime.now(),
          ),
        ) {
    on<AppointmentFormInitialized>(_initAppointmentForm);
    on<AppointmentFormAdded>(_addAppointment);
    on<AppointmentFormEdited>(_editAppointment);
    on<AppointmentFormDateChanged>(_changeDate);
    on<AppointmentFormStartTimeChanged>(_changeStartTime);
    on<AppointmentFormEndTimeChanged>(_changeEndTime);
    on<AppointmentFormServicesChanged>(_changeServices);
  }

  final AppointmentRepository appointmentRepository;
  final UserRepository userRepository;

  Future<void> _initAppointmentForm(
    AppointmentFormInitialized event,
    Emitter<AppointmentFormState> emit,
  ) async {
    try {
      /// Get a list of all users
      final users = await userRepository.getUsers();

      emit(state.copyWith(status: AppointmentFormStatus.initInProgress));

      /// If have an appointment to edit
      if (event.appointment != null) {
        /// Init appointment's properties from event
        emit(
          state.copyWith(
            user: users.singleWhere((e) => e.id == event.appointment!.userId),
            date: event.appointment!.date,
            startTime: event.appointment!.startTime,
            endTime: event.appointment!.endTime,
            services: event.appointment!.services,
            description: event.appointment!.description,
          ),
        );
      } else {
        final user = await userRepository.getUser();
        DateTime initDateTime = _initDateTime(event.initDateTime);

        /// Init new appointment's properties
        emit(
          state.copyWith(
            user: user,
            date: initDateTime,
            startTime: initDateTime,
            endTime: autoAddHalfHour(initDateTime),
          ),
        );
      }

      emit(
        state.copyWith(
          status: AppointmentFormStatus.initSuccess,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: AppointmentFormStatus.initFailure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _addAppointment(
    AppointmentFormAdded event,
    Emitter<AppointmentFormState> emit,
  ) async {
    try {
      /// Get a list of all appointments
      final appointments = await appointmentRepository.getAllAppointments();

      final error = _checkAppointment(
        event.services,
        appointments,
        event.startTime!,
        event.endTime!,
      );

      if (error != null) {
        emit(
          state.copyWith(
            status: AppointmentFormStatus.addFailure,
            error: error,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AppointmentFormStatus.addInProgress,
          ),
        );

        /// Wait for adding an appointment
        await appointmentRepository.addAppointment(
          Appointment(
            userId: state.user!.id,
            date: event.date!,
            startTime: event.startTime!,
            endTime: event.endTime!,
            services: event.services!,
            description: event.description!,
          ),
        );

        emit(
          state.copyWith(
            status: AppointmentFormStatus.addSuccess,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AppointmentFormStatus.addFailure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _editAppointment(
    AppointmentFormEdited event,
    Emitter<AppointmentFormState> emit,
  ) async {
    try {
      final appointments = await appointmentRepository.getAllAppointments();

      final error = _checkAppointment(
        event.services,
        appointments,
        event.startTime!,
        event.endTime!,
      );

      if (error != null) {
        emit(
          state.copyWith(
            status: AppointmentFormStatus.editFailure,
            error: error,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AppointmentFormStatus.editInProgress,
          ),
        );

        await appointmentRepository.editAppointment(
          Appointment(
            userId: state.user!.id,
            date: event.date!,
            startTime: event.startTime!,
            endTime: event.endTime!,
            services: event.services!,
            description: event.description!,
          ),
        );

        emit(
          state.copyWith(
            status: AppointmentFormStatus.editSuccess,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AppointmentFormStatus.editFailure,
          error: e.toString(),
        ),
      );
    }
  }

  void _changeDate(
    AppointmentFormDateChanged event,
    Emitter<AppointmentFormState> emit,
  ) {
    if (event.date != null && event.date != state.date) {
      /// Define variables [date], [startTime], [endTime] from date in event
      final date = event.date!;
      final startTime = setDateTime(
        date,
        getTime(state.startTime!),
      );
      final endTime = setDateTime(
        date,
        getTime(state.endTime!),
      );

      emit(
        state.copyWith(
          status: AppointmentFormStatus.beforeChange,
          error: null,
        ),
      );

      /// Check if [startTime], [endTime] have any errors
      final String? error = _checkTime(startTime, endTime);

      if (error != null) {
        emit(
          state.copyWith(
            status: AppointmentFormStatus.changeFailure,
            error: error,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AppointmentFormStatus.changeSuccess,
            date: date,
            startTime: startTime,
            endTime: endTime,
          ),
        );
      }
    }
  }

  void _changeStartTime(
    AppointmentFormStartTimeChanged event,
    Emitter<AppointmentFormState> emit,
  ) {
    if (event.startTime != null &&
        event.startTime != getTime(state.startTime!)) {
      /// Define variables [startTime], [endTime] from [startTime] in event
      final startTime = setDateTime(
        state.date!,
        event.startTime!,
      );
      final endTime = autoAddHalfHour(startTime);

      emit(
        state.copyWith(
          status: AppointmentFormStatus.beforeChange,
          error: null,
        ),
      );

      /// Check if [startTime], [endTime] have any errors
      final String? error = _checkTime(startTime, endTime);

      if (error != null) {
        emit(
          state.copyWith(
            status: AppointmentFormStatus.changeFailure,
            error: error,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AppointmentFormStatus.changeSuccess,
            startTime: startTime,
            endTime: endTime,
          ),
        );
      }
    }
  }

  void _changeEndTime(
    AppointmentFormEndTimeChanged event,
    Emitter<AppointmentFormState> emit,
  ) {
    if (event.endTime != null && event.endTime != getTime(state.endTime!)) {
      /// Define variables [endTime] from [endTime] in event
      final endTime = setDateTime(
        state.date!,
        event.endTime!,
      );

      emit(
        state.copyWith(
          status: AppointmentFormStatus.beforeChange,
          error: null,
        ),
      );

      /// Check if [startTime], [endTime] have any errors
      final String? error = _checkTime(state.startTime!, endTime);

      if (error != null) {
        emit(
          state.copyWith(
            status: AppointmentFormStatus.changeFailure,
            error: error,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AppointmentFormStatus.changeSuccess,
            endTime: endTime,
          ),
        );
      }
    }
  }

  void _changeServices(
    AppointmentFormServicesChanged event,
    Emitter<AppointmentFormState> emit,
  ) {
    emit(
      state.copyWith(
        services: event.services,
        status: AppointmentFormStatus.changeSuccess,
      ),
    );
  }

  /// Check [startTime] and [endTime] conditions
  String? _checkTime(
    DateTime startTime,
    DateTime endTime,
  ) {
    /// If have any errors, return an error [String]
    if (isBeforeNow(startTime) || isBeforeNow(endTime)) {
      return ErrorMessage.beforeNow;
    }
    if (!isAfterStartTime(startTime, endTime)) {
      return ErrorMessage.differentTime;
    }
    if (isBreakTime(startTime) || isBreakTime(endTime)) {
      return ErrorMessage.breakConflict;
    }
    if (isClosedTime(startTime) || isClosedTime(endTime)) {
      return ErrorMessage.closedConflict;
    }

    /// If not have any errors, return null
    return null;
  }

  String? _checkAppointment(
    String? services,
    List<Appointment> appointments,
    DateTime startTime,
    DateTime endTime,
  ) {
    /// Check if [services] is empty
    return services?.isEmpty ?? true
        ? ErrorMessage.emptyServices

        /// Check if full appointments during [startTime] to [endTime]
        : isFullAppointments(appointments, startTime, endTime)
            ? ErrorMessage.fullAppointments
            : null;
  }

  /// Check current time is in break time or closed time
  DateTime _initDateTime(DateTime dateTime) {
    final initEndTime = autoAddHalfHour(dateTime);

    /// If in break time, set the time to 3:20 PM
    if (isBreakTime(dateTime) || isBreakTime(initEndTime)) {
      return DateTime(
          dateTime.year, dateTime.month, dateTime.day, 15, 20, 0, 0, 0);
    }

    /// If in closed time, set the time to 8:00 AM next day
    if (isClosedTime(dateTime) || isClosedTime(initEndTime)) {
      return initOpenTime(dateTime);
    }

    /// If not have any time conflicts, set the time to current time
    return dateTime;
  }
}
