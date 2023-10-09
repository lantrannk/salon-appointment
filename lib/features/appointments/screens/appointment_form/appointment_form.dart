import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/generated/l10n.dart';
import '../../../../core/utils/common.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/repository/user_repository.dart';
import '../../model/appointment.dart';
import '../../repository/appointment_repository.dart';
import '../appointment/appointments_screen.dart';
import 'bloc/appointment_form_bloc.dart';

class AppointmentForm extends StatefulWidget {
  const AppointmentForm({
    this.appointment,
    super.key,
  });

  final Appointment? appointment;

  @override
  State<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final descpController = TextEditingController();

  final descpFocusNode = FocusNode();

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
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double indicatorHeight = screenHeight / 2;
    final l10n = S.of(context);

    return RepositoryProvider(
      create: (context) => AppointmentRepository(),
      child: BlocProvider<AppointmentFormBloc>(
        create: (context) => AppointmentFormBloc(
          appointmentRepository: context.read<AppointmentRepository>(),
          userRepository: context.read<UserRepository>(),
        )..add(
            AppointmentFormInitialized(
              appointment: widget.appointment,
            ),
          ),
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
              child: BlocConsumer<AppointmentFormBloc, AppointmentFormState>(
                listener: (ctx, state) {
                  switch (state.status) {
                    case AppointmentFormStatus.changeFailure:
                    case AppointmentFormStatus.addFailure:
                    case AppointmentFormStatus.editFailure:
                    case AppointmentFormStatus.initFailure:
                      SASnackBar.show(
                        context: ctx,
                        message: appointmentFormFailure(
                          l10n,
                          state.error,
                        ),
                        isSuccess: false,
                      );
                      break;
                    case AppointmentFormStatus.addInProgress:
                    case AppointmentFormStatus.editInProgress:
                      loadingIndicator.show(
                        context: ctx,
                        height: indicatorHeight,
                      );
                      break;
                    case AppointmentFormStatus.addSuccess:
                    case AppointmentFormStatus.editSuccess:
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
                            focusedDay: state.date,
                          ),
                        ),
                      );
                      break;
                    default:
                      return;
                  }
                },
                builder: (context, state) {
                  if (state.status == AppointmentFormStatus.initInProgress) {
                    return Center(
                      child: SAIndicator(
                        color: colorScheme.primary,
                      ),
                    );
                  }
                  if (state.status == AppointmentFormStatus.initFailure) {
                    return const SizedBox.shrink();
                  }
                  return SizedBox(
                    height: screenHeight - keyboardHeight,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          Text(
                            state.user?.name ?? '',
                            style: textTheme.titleLarge!.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          DatePicker(
                            dateTime: state.date ?? today,
                            onPressed: () async {
                              final DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: state.date!,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(state.date!.year + 5),
                              );

                              context.read<AppointmentFormBloc>().add(
                                    AppointmentFormDateChanged(
                                      date: date,
                                    ),
                                  );
                            },
                          ),
                          const SizedBox(height: 12),
                          TimePicker(
                            startTime: state.startTime ?? today,
                            endTime: state.endTime ?? today,
                            onStartTimePressed: () async {
                              final TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: getTime(state.startTime!),
                              );

                              context.read<AppointmentFormBloc>().add(
                                    AppointmentFormStartTimeChanged(
                                      startTime: time,
                                    ),
                                  );
                            },
                            onEndTimePressed: () async {
                              final TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: getTime(state.endTime!),
                              );

                              context.read<AppointmentFormBloc>().add(
                                    AppointmentFormEndTimeChanged(
                                      endTime: time,
                                    ),
                                  );
                            },
                          ),
                          const SizedBox(height: 12),
                          Dropdown(
                            items: allServices,
                            hint: l10n.servicesDropdownHint,
                            style: textTheme.labelSmall!.copyWith(
                              color: colorScheme.onSurface,
                            ),
                            selectedValue: state.services,
                            onChanged: (value) {
                              context.read<AppointmentFormBloc>().add(
                                    AppointmentFormServicesChanged(
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
                              onPressed: () {
                                context.read<AppointmentFormBloc>().add(
                                      isNew
                                          ? AppointmentFormAdded(
                                              date: state.date,
                                              startTime: state.startTime,
                                              endTime: state.endTime,
                                              services: state.services,
                                              description: description(
                                                l10n,
                                              ),
                                            )
                                          : AppointmentFormEdited(
                                              date: state.date,
                                              startTime: state.startTime,
                                              endTime: state.endTime,
                                              services: state.services,
                                              description: description(
                                                l10n,
                                              ),
                                            ),
                                    );
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
