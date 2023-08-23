import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/assets.dart';
import '../../../core/constants/constants.dart';
import '../../../core/generated/l10n.dart';
import '../../../core/storage/appointment_storage.dart';
import '../../../core/storage/user_storage.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/model/user.dart';
import '../api/appointment_api.dart';
import '../bloc/appointment_bloc.dart';
import '../model/appointment.dart';
import '../repository/appointment_repository.dart';
import '../screens/appointments_screen.dart';

class NewAppointmentScreen extends StatefulWidget {
  const NewAppointmentScreen({
    required this.selectedDay,
    this.user,
    this.appointment,
    super.key,
  });

  final User? user;
  final Appointment? appointment;
  final DateTime selectedDay;

  @override
  State<NewAppointmentScreen> createState() => _NewAppointmentScreenState();
}

class _NewAppointmentScreenState extends State<NewAppointmentScreen> {
  final descpController = TextEditingController();
  final appointmentApi = AppointmentApi(http.Client());
  final appointmentRepo = AppointmentRepository();
  final userStorage = UserStorage();

  final nameFocusNode = FocusNode();
  final descpFocusNode = FocusNode();

  late DateTime dateTime = widget.appointment?.date ??
      setDateTime(
        widget.selectedDay,
        TimeOfDay.fromDateTime(DateTime.now()),
      );
  late DateTime startTime = widget.appointment?.startTime ??
      setDateTime(
        widget.selectedDay,
        TimeOfDay.fromDateTime(DateTime.now()),
      );
  late DateTime endTime =
      widget.appointment?.endTime ?? autoAddHalfHour(startTime);
  late String? services = widget.appointment?.services;

  @override
  void initState() {
    descpController.text = widget.appointment?.description ?? '';
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
    final appointmentApi = AppointmentApi(http.Client());

    return BlocProvider<AppointmentBloc>(
      create: (_) => AppointmentBloc(
        appointmentApi,
        appointmentRepo,
        userStorage,
      )..add(UserLoad()),
      child: Scaffold(
        appBar: AppBar(
          title: SAText.appBarTitle(
            text: widget.appointment == null
                ? l10n.newAppointmentAppBarTitle
                : l10n.editAppointmentAppBarTitle,
            style: textTheme.titleLarge!,
          ),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: SAButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                child: SAIcons(
                  icon: Assets.closeIcon,
                  color: colorScheme.secondaryContainer,
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
                  case UserLoadFailure:
                    SASnackBar.show(
                      context: context,
                      message: l10n.addSuccess,
                      isSuccess: true,
                    );
                    Navigator.pop(context);
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
                if (state is UserLoadSuccess) {
                  final User user = widget.user ?? state.user;
                  return Column(
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        user.name,
                        style: textTheme.titleLarge,
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
                          if (date != null) {
                            final tempDateTime = date;
                            final tempStartTime = setDateTime(
                              tempDateTime,
                              TimeOfDay.fromDateTime(startTime),
                            );
                            final tempEndTime = setDateTime(
                              tempDateTime,
                              TimeOfDay.fromDateTime(endTime),
                            );

                            if (isBeforeNow(tempStartTime) ||
                                isBeforeNow(tempEndTime)) {
                              SASnackBar.show(
                                context: context,
                                message: l10n.invalidStartTimeError,
                                isSuccess: false,
                              );
                            } else if (isBreakTime(tempStartTime) ||
                                isBreakTime(tempEndTime)) {
                              SASnackBar.show(
                                context: context,
                                message: l10n.breakTimeConflictError,
                                isSuccess: false,
                              );
                            } else if (isClosedTime(tempStartTime) ||
                                isClosedTime(tempEndTime)) {
                              SASnackBar.show(
                                context: context,
                                message: l10n.closedTimeError,
                                isSuccess: false,
                              );
                            } else if (date != dateTime) {
                              setState(() {
                                dateTime = tempDateTime;
                                startTime = tempStartTime;
                                endTime = tempEndTime;
                              });
                            }
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
                            initialTime: TimeOfDay.fromDateTime(startTime),
                          );
                          if (time != null) {
                            final DateTime tempStartTime =
                                setDateTime(dateTime, time);

                            if (isBeforeNow(tempStartTime)) {
                              SASnackBar.show(
                                context: context,
                                message: l10n.invalidStartTimeError,
                                isSuccess: false,
                              );
                            } else if (isBreakTime(tempStartTime)) {
                              SASnackBar.show(
                                context: context,
                                message: l10n.breakTimeConflictError,
                                isSuccess: false,
                              );
                            } else if (isClosedTime(tempStartTime)) {
                              SASnackBar.show(
                                context: context,
                                message: l10n.closedTimeError,
                                isSuccess: false,
                              );
                            } else if (time !=
                                TimeOfDay.fromDateTime(startTime)) {
                              setState(() {
                                startTime = tempStartTime;
                                endTime = autoAddHalfHour(startTime);
                              });
                            }
                          }
                        },
                        onEndTimePressed: () async {
                          final TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(endTime),
                          );
                          if (time != null) {
                            final DateTime tempEndTime =
                                setDateTime(dateTime, time);

                            if (!isAfterStartTime(startTime, tempEndTime)) {
                              SASnackBar.show(
                                context: context,
                                message: l10n.invalidEndTimeError,
                                isSuccess: false,
                              );
                            } else if (isBreakTime(tempEndTime)) {
                              SASnackBar.show(
                                context: context,
                                message: l10n.breakTimeConflictError,
                                isSuccess: false,
                              );
                            } else if (isClosedTime(tempEndTime)) {
                              SASnackBar.show(
                                context: context,
                                message: l10n.closedTimeError,
                                isSuccess: false,
                              );
                            } else if (time !=
                                TimeOfDay.fromDateTime(endTime)) {
                              setState(() {
                                endTime = tempEndTime;
                              });
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      Dropdown(
                          items: items,
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
                        color: colorScheme.secondaryContainer,
                        maxLines: 4,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: colorScheme.secondaryContainer,
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
                                await AppointmentStorage.getAppointments();

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
                                              userId: user.id,
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
                          bgColor: colorScheme.primary,
                          child: Text(
                            widget.appointment == null
                                ? l10n.createAppointmentButton
                                : l10n.editAppointmentButton,
                            style: textTheme.labelMedium!.copyWith(
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
