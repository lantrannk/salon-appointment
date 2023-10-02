import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/appointment.dart';

part 'appointment_form_event.dart';
part 'appointment_form_state.dart';

class AppointmentFormBloc
    extends Bloc<AppointmentFormEvent, AppointmentFormState> {
  AppointmentFormBloc() : super(const AppointmentFormState()) {
    on<AppointmentFormEvent>((event, emit) {});
  }
}
