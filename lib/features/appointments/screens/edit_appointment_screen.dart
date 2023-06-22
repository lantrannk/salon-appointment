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
  final nameController = TextEditingController();
  final descpController = TextEditingController();

  final nameFocusNode = FocusNode();
  final descpFocusNode = FocusNode();

  late User _user;
  late Appointment _appointment;

  @override
  void initState() {
    super.initState();
    _appointment = widget.appointment;
    _user = widget.user;
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
                      dateTime: _appointment.date,
                      onPressed: () async {
                        final DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: _appointment.date,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(_appointment.date.year + 5),
                        );

                        if (date != null && date != _appointment.date) {
                          setState(() {
                            _appointment
                              ..date = date
                              ..startTime = setDateTime(
                                _appointment.date,
                                TimeOfDay.fromDateTime(_appointment.startTime),
                              )
                              ..endTime = setDateTime(
                                _appointment.date,
                                TimeOfDay.fromDateTime(_appointment.endTime),
                              );
                          });
                        }
                      }),
                  const SizedBox(height: 12),
                  TimePicker(
                    startTime: _appointment.startTime,
                    endTime: _appointment.endTime,
                    onStartTimePressed: () async {
                      final TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime:
                            TimeOfDay.fromDateTime(_appointment.startTime),
                      );
                      if (time != null &&
                          time !=
                              TimeOfDay.fromDateTime(_appointment.startTime)) {
                        setState(() {
                          _appointment
                            ..startTime = setDateTime(
                              _appointment.date,
                              time,
                            )
                            ..endTime = autoAddHalfHour(_appointment.startTime);
                        });
                      }
                    },
                    onEndTimePressed: () async {
                      final TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime:
                            TimeOfDay.fromDateTime(_appointment.endTime),
                      );
                      if (time != null) {
                        final DateTime tempEndTime =
                            setDateTime(_appointment.date, time);
                        if (!isAfterStartTime(
                            _appointment.startTime, tempEndTime)) {
                          SASnackBar.show(
                            context: context,
                            message: S.of(context).invalidEndTimeError,
                            isSuccess: false,
                          );
                        } else if (time !=
                            TimeOfDay.fromDateTime(_appointment.endTime)) {
                          setState(() {
                            _appointment.endTime =
                                setDateTime(_appointment.date, time);
                          });
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Dropdown(
                      items: items,
                      selectedValue: _appointment.services,
                      onChanged: (value) {
                        setState(() {
                          _appointment.services = value!;
                        });
                      }),
                  const SizedBox(height: 12),
                  Input(
                    controller: descpController,
                    text: _appointment.description,
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
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (isBreakTime(
                        _appointment.startTime,
                        _appointment.endTime,
                      )) {
                        SASnackBar.show(
                          context: context,
                          message: l10n.breakTimeConflictError,
                          isSuccess: false,
                        );
                      } else if (isClosedTime(
                        _appointment.startTime,
                        _appointment.endTime,
                      )) {
                        SASnackBar.show(
                          context: context,
                          message: l10n.closedTimeError,
                          isSuccess: false,
                        );
                      } else {
                        context.read<AppointmentBloc>().add(
                              AppointmentEdit(
                                appointment: Appointment(
                                  id: _appointment.id,
                                  userId: _appointment.userId,
                                  date: _appointment.date,
                                  startTime: _appointment.startTime,
                                  endTime: _appointment.endTime,
                                  services: _appointment.services,
                                  description: descpController.text == ''
                                      ? _appointment.description
                                      : descpController.text,
                                ),
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
