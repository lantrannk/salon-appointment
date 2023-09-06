import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/constants.dart';
import '../../../core/generated/l10n.dart';
import '../../../core/utils/common.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/model/user.dart';
import '../../auth/repository/user_repository.dart';
import '../bloc/appointment_bloc.dart';
import '../model/appointment.dart';
import '../repository/appointment_repository.dart';
import '../screens/appointments_screen.dart';

class AppointmentForm extends StatefulWidget {
  const AppointmentForm({
    required this.selectedDay,
    this.user,
    this.appointment,
    super.key,
  });

  final User? user;
  final Appointment? appointment;
  final DateTime selectedDay;

  @override
  State<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final descpController = TextEditingController();
  final appointmentRepo = AppointmentRepository();
  final userRepo = UserRepository();

  final nameFocusNode = FocusNode();
  final descpFocusNode = FocusNode();

  late DateTime dateTime = widget.appointment?.date ??
      setDateTime(
        widget.selectedDay,
        getTime(DateTime.now()),
      );
  late DateTime startTime = widget.appointment?.startTime ??
      setDateTime(
        widget.selectedDay,
        getTime(DateTime.now()),
      );
  late DateTime endTime =
      widget.appointment?.endTime ?? autoAddHalfHour(startTime);

  late String? services = widget.appointment?.services;
  late User? user;

  @override
  void initState() {
    descpController.text = widget.appointment?.description ?? '';
    user = widget.user;
    super.initState();
  }

  @override
  void dispose() {
    descpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double indicatorHeight = MediaQuery.of(context).size.height / 2;
    final l10n = S.of(context);

    return BlocProvider<AppointmentBloc>(
      create: (_) => AppointmentBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      )..add(AppointmentInitialize()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.appointment == null
                ? l10n.newAppointmentAppBarTitle
                : l10n.editAppointmentAppBarTitle,
          ),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: SAButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                child: SAIcons(
                  icon: Assets.closeIcon,
                  color: colorScheme.tertiaryContainer,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: BlocConsumer<AppointmentBloc, AppointmentState>(
              listener: (ctx, state) {
                switch (state.runtimeType) {
                  case AppointmentInitializeSuccess:
                    user ??= state.user;
                    break;
                  case AppointmentInitializeFailure:
                    Navigator.pop(ctx);
                    SASnackBar.show(
                      context: context,
                      message: state.error!,
                      isSuccess: false,
                    );
                    break;
                  case AppointmentDateTimeChangeSuccess:
                    dateTime = state.date;
                    startTime = state.startTime;
                    endTime = state.endTime;
                    break;
                  case AppointmentDateTimeChangeFailure:
                    SASnackBar.show(
                      context: ctx,
                      message: dateTimeChangeFailure(
                        context,
                        state.error!,
                      ),
                      isSuccess: false,
                    );
                    break;
                  case AppointmentAddInProgress:
                    loadingIndicator.show(
                      context: ctx,
                      height: indicatorHeight,
                    );
                    break;
                  case AppointmentAddSuccess:
                  case AppointmentEditSuccess:
                    loadingIndicator.hide(ctx);

                    SASnackBar.show(
                      context: context,
                      message: widget.appointment == null
                          ? l10n.addSuccess
                          : l10n.updateSuccess,
                      isSuccess: true,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentScreen(
                          focusedDay: dateTime,
                        ),
                      ),
                    );
                    break;
                  case AppointmentAddFailure:
                    SASnackBar.show(
                      context: context,
                      message: state.error!,
                      isSuccess: false,
                    );
                    break;
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      user?.name ?? '',
                      style: textTheme.titleLarge!.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DatePicker(
                      dateTime: dateTime,
                      onPressed: () async {
                        final DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: dateTime,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(dateTime.year + 5),
                        );
                        if (date != null && date != dateTime) {
                          context.read<AppointmentBloc>().add(
                                AppointmentDateTimeChanged(
                                  date: date,
                                  startTime: getTime(startTime),
                                  endTime: getTime(endTime),
                                ),
                              );
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TimePicker(
                      startTime: startTime,
                      endTime: endTime,
                      onStartTimePressed: () async {
                        final TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: getTime(startTime),
                        );
                        if (time != null && time != getTime(startTime)) {
                          context.read<AppointmentBloc>().add(
                                AppointmentDateTimeChanged(
                                  date: dateTime,
                                  startTime: time,
                                  endTime: getTime(
                                    autoAddHalfHour(
                                      setDateTime(dateTime, time),
                                    ),
                                  ),
                                ),
                              );
                        }
                      },
                      onEndTimePressed: () async {
                        final TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: getTime(endTime),
                        );
                        if (time != null && time != getTime(endTime)) {
                          context.read<AppointmentBloc>().add(
                                AppointmentDateTimeChanged(
                                  date: dateTime,
                                  startTime: getTime(startTime),
                                  endTime: time,
                                ),
                              );
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Dropdown(
                        items: allServices,
                        hint: l10n.servicesDropdownHint,
                        selectedValue: services,
                        onChanged: (value) {
                          setState(() {
                            services = value;
                          });
                        }),
                    const SizedBox(height: 12),
                    Input(
                      controller: descpController,
                      text: l10n.description,
                      focusNode: descpFocusNode,
                      onEditCompleted: () {
                        FocusScope.of(context).unfocus();
                      },
                      color: colorScheme.tertiaryContainer,
                      maxLines: 4,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: colorScheme.tertiaryContainer,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 44,
                      width: double.infinity,
                      child: SAButton.elevated(
                        onPressed: () async {
                          final appointments =
                              await appointmentRepo.getAllAppointments();

                          if (isFullAppointments(
                            appointments,
                            startTime,
                            endTime,
                          )) {
                            SASnackBar.show(
                              context: context,
                              message: l10n.fullAppointmentsError,
                              isSuccess: false,
                            );
                          } else if (services == null) {
                            SASnackBar.show(
                              context: context,
                              message: l10n.emptyServicesError,
                              isSuccess: false,
                            );
                          } else {
                            context.read<AppointmentBloc>().add(
                                  widget.appointment == null
                                      ? AppointmentAdded(
                                          appointment: Appointment(
                                            userId: user!.id,
                                            date: dateTime,
                                            startTime: startTime,
                                            endTime: endTime,
                                            services: services!,
                                            description:
                                                descpController.text == ''
                                                    ? l10n.defaultDescription
                                                    : descpController.text,
                                          ),
                                        )
                                      : AppointmentEdited(
                                          appointment:
                                              widget.appointment!.copyWith(
                                            date: dateTime,
                                            startTime: startTime,
                                            endTime: endTime,
                                            services: services,
                                            description:
                                                descpController.text == ''
                                                    ? l10n.defaultDescription
                                                    : descpController.text,
                                          ),
                                        ),
                                );
                          }
                        },
                        child: Text(
                          widget.appointment == null
                              ? l10n.createAppointmentButton
                              : l10n.editAppointmentButton,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
