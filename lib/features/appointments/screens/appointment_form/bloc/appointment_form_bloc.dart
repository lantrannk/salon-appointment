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
  }) : super(const AppointmentFormState()) {
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
      final users = await userRepository.getUsers();

      if (event.appointment != null) {
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

        emit(
          state.copyWith(
            user: user,
            date: today,
            startTime: today,
            endTime: autoAddHalfHour(today),
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
      emit(
        state.copyWith(
          status: AppointmentFormStatus.addInProgress,
        ),
      );
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
    } on Exception catch (e) {
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
    } on Exception catch (e) {
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

      final String? error = _checkDateTime(startTime, endTime);

      if (error != null) {
        emit(
          state.copyWith(
            status: AppointmentFormStatus.changeDateFailure,
            error: error,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AppointmentFormStatus.changeDateSuccess,
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

      final String? error = _checkDateTime(startTime, endTime);

      if (error != null) {
        emit(
          state.copyWith(
            status: AppointmentFormStatus.changeStartTimeFailure,
            error: error,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AppointmentFormStatus.changeStartTimeSuccess,
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

      final String? error = _checkDateTime(state.startTime!, endTime);

      if (error != null) {
        emit(
          state.copyWith(
            status: AppointmentFormStatus.changeEndTimeFailure,
            error: error,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AppointmentFormStatus.changeEndTimeSuccess,
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
        status: AppointmentFormStatus.changeServicesSuccess,
      ),
    );
  }

  String? _checkDateTime(
    DateTime startTime,
    DateTime endTime,
  ) {
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
    return null;
  }

  Future<bool> _checkAllInformationFilled(
    String? services,
    DateTime startTime,
    DateTime endTime,
  ) async {
    final appointments = await appointmentRepository.getAllAppointments();

    return services == null ||
        isFullAppointments(
          appointments,
          startTime,
          endTime,
        );
  }
}
