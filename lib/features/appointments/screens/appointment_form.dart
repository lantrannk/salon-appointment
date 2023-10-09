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
import 'appointment/appointments_screen.dart';

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
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double indicatorHeight = screenHeight / 2;
    final l10n = S.of(context);

    return RepositoryProvider(
      create: (context) => AppointmentRepository(),
      child: BlocProvider<AppointmentBloc>(
        create: (context) => AppointmentBloc(
          appointmentRepository: context.read<AppointmentRepository>(),
          userRepository: context.read<UserRepository>(),
        )..add(AppointmentInitialize()),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              isNew
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
                    color: colorScheme.onSurface,
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
                    case AppointmentDateTimeChangeSuccess:
                      dateTime = state.date;
                      startTime = state.startTime;
                      endTime = state.endTime;
                      break;
                    case AppointmentServicesChangeSuccess:
                      services = state.services;
                      break;
                    case AppointmentDateTimeChangeFailure:
                      SASnackBar.show(
                        context: ctx,
                        message: dateTimeChangeFailure(
                          l10n,
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
                        message: isNew ? l10n.addSuccess : l10n.updateSuccess,
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
                    case AppointmentInitializeFailure:
                    case AppointmentAddFailure:
                      Navigator.of(context).pop();
                      SASnackBar.show(
                        context: context,
                        message: state.error!,
                        isSuccess: false,
                      );
                      break;
                  }
                },
                builder: (context, state) {
                  return SizedBox(
                    height: screenHeight - keyboardHeight,
                    child: SingleChildScrollView(
                      child: Column(
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
                            style: textTheme.labelSmall!.copyWith(
                              color: colorScheme.onSurface,
                            ),
                            selectedValue: services,
                            onChanged: (value) {
                              context.read<AppointmentBloc>().add(
                                    AppointmentServicesChanged(
                                      services: value!,
                                    ),
                                  );
                            },
                          ),
                          const SizedBox(height: 12),
                          Input(
                            controller: descpController,
                            text: l10n.description,
                            focusNode: descpFocusNode,
                            onEditCompleted: () {
                              FocusScope.of(context).unfocus();
                            },
                            color: colorScheme.onSurface,
                            maxLines: 4,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: colorScheme.onSurface,
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
                                final appointments = await context
                                    .read<AppointmentRepository>()
                                    .getAllAppointments();

                                if (services == null) {
                                  SASnackBar.show(
                                    context: context,
                                    message: l10n.emptyServicesError,
                                    isSuccess: false,
                                  );
                                } else if (isFullAppointments(
                                  appointments,
                                  startTime,
                                  endTime,
                                )) {
                                  SASnackBar.show(
                                    context: context,
                                    message: l10n.fullAppointmentsError,
                                    isSuccess: false,
                                  );
                                } else {
                                  context.read<AppointmentBloc>().add(
                                        isNew
                                            ? AppointmentAdded(
                                                appointment: Appointment(
                                                  userId: user!.id,
                                                  date: dateTime,
                                                  startTime: startTime,
                                                  endTime: endTime,
                                                  services: services!,
                                                  description: description(
                                                    l10n,
                                                  ),
                                                ),
                                              )
                                            : AppointmentEdited(
                                                appointment: widget.appointment!
                                                    .copyWith(
                                                  date: dateTime,
                                                  startTime: startTime,
                                                  endTime: endTime,
                                                  services: services,
                                                  description: description(
                                                    l10n,
                                                  ),
                                                ),
                                              ),
                                      );
                                }
                              },
                              child: Text(
                                isNew
                                    ? l10n.createAppointmentButton
                                    : l10n.editAppointmentButton,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get isNew => widget.appointment == null;

  String description(S l10n) => descpController.text.isEmpty
      ? l10n.defaultDescription
      : descpController.text;
}
