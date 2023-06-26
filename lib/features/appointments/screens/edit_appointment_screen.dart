import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/assets.dart';
import '../../../core/constants/constants.dart';
import '../../../core/generated/l10n.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/date_picker.dart';
import '../../../core/widgets/dropdown.dart';
import '../../../core/widgets/icons.dart';
import '../../../core/widgets/input.dart';
import '../../../core/widgets/snack_bar.dart';
import '../../../core/widgets/text.dart';
import '../../../core/widgets/time_picker.dart';
import '../../auth/model/user.dart';
import '../bloc/appointment_bloc.dart';
import '../model/appointment.dart';

class EditAppointment extends StatefulWidget {
  const EditAppointment({
    required this.appointment,
    required this.user,
    super.key,
  });

  final Appointment appointment;
  final User user;

  @override
  State<EditAppointment> createState() => _EditAppointmentState();
}

class _EditAppointmentState extends State<EditAppointment> {
  final descpController = TextEditingController();

  final nameFocusNode = FocusNode();
  final descpFocusNode = FocusNode();

  late User _user;
  late Appointment _appointment;
  late DateTime dateTime = widget.appointment.date;
  late DateTime startTime = widget.appointment.startTime;
  late DateTime endTime = widget.appointment.endTime;
  late String services = widget.appointment.services;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    descpController.text = widget.appointment.description;
  }

  @override
  void dispose() {
    descpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: SAText.appBarTitle(
          text: l10n.editAppointmentAppBarTitle,
          style: textTheme.titleLarge!,
        ),
        automaticallyImplyLeading: false,
        actions: [
          SAButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            child: const SAIcons(
              icon: Assets.closeIcon,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: BlocBuilder<AppointmentBloc, AppointmentState>(
            builder: (context, state) {
              return Column(
                children: [
                  const SizedBox(height: 12),
                  Text(
                    _user.name,
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

                        if (date != null && date != dateTime) {
                          setState(() {
                            dateTime = date;
                            startTime = setDateTime(
                              dateTime,
                              TimeOfDay.fromDateTime(startTime),
                            );
                            endTime = setDateTime(
                              dateTime,
                              TimeOfDay.fromDateTime(endTime),
                            );
                          });
                        }
                      }),
                  const SizedBox(height: 12),
                  TimePicker(
                    startTime: startTime,
                    endTime: endTime,
                    onStartTimePressed: () async {
                      final TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(startTime),
                      );
                      if (time != null &&
                          time != TimeOfDay.fromDateTime(startTime)) {
                        setState(() {
                          startTime = setDateTime(
                            dateTime,
                            time,
                          );
                          endTime = autoAddHalfHour(startTime);
                        });
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
                            message: S.of(context).invalidEndTimeError,
                            isSuccess: false,
                          );
                        } else if (time != TimeOfDay.fromDateTime(endTime)) {
                          setState(() {
                            endTime = setDateTime(dateTime, time);
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
                          services = value!;
                        });
                      }),
                  const SizedBox(height: 12),
                  Input(
                    controller: descpController,
                    text: S.of(context).description,
                    focusNode: descpFocusNode,
                    textInputAction: TextInputAction.done,
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
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (isBreakTime(
                        startTime,
                        endTime,
                      )) {
                        SASnackBar.show(
                          context: context,
                          message: l10n.breakTimeConflictError,
                          isSuccess: false,
                        );
                      } else if (isClosedTime(
                        startTime,
                        endTime,
                      )) {
                        SASnackBar.show(
                          context: context,
                          message: l10n.closedTimeError,
                          isSuccess: false,
                        );
                      } else {
                        FocusScope.of(context).unfocus();

                        _appointment = widget.appointment.copyWith(
                          date: dateTime,
                          startTime: startTime,
                          endTime: endTime,
                          services: services,
                          description: descpController.text == ''
                              ? S.of(context).defaultDescription
                              : descpController.text,
                        );

                        context.read<AppointmentBloc>().add(
                              AppointmentEdit(
                                appointment: _appointment,
                              ),
                            );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                    ),
                    child: Text(
                      l10n.editAppointmentButton,
                      style: textTheme.labelMedium!.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
