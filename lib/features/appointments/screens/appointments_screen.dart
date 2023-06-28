import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/constants/assets.dart';
import '../../../core/constants/date_format.dart';
import '../../../core/generated/l10n.dart';
import '../../../core/layouts/main_layout.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/model/user.dart';
import '../bloc/appointment_bloc.dart';
import '../model/appointment.dart';
import '../repository/appointment_repository.dart';
import 'new_appointment_screen.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({
    this.focusedDay,
    super.key,
  });

  final DateTime? focusedDay;

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final appointmentRepo = AppointmentRepository();

  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  DateTime? _focusedDay;
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.focusedDay ?? DateTime.now();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double indicatorHeight = MediaQuery.of(context).size.height / 2;
    final l10n = S.of(context);

    return BlocProvider<AppointmentBloc>(
      create: (_) => AppointmentBloc()..add(AppointmentLoad(_selectedDay!)),
      child: MainLayout(
        currentIndex: 0,
        selectedDay: _selectedDay!,
        title: l10n.appointmentAppBarTitle,
        child: Column(
          children: [
            BlocBuilder<AppointmentBloc, AppointmentState>(
                builder: (ctx, state) {
              return TableCalendar<Appointment>(
                headerVisible: false,
                firstDay: firstDay,
                lastDay: lastDay,
                focusedDay: _focusedDay!,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                calendarFormat: CalendarFormat.week,
                rangeSelectionMode: _rangeSelectionMode,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  isTodayHighlighted: false,
                  cellMargin: EdgeInsets.zero,
                  cellPadding: const EdgeInsets.only(bottom: 4),
                  tablePadding: const EdgeInsets.symmetric(vertical: 4),
                  selectedTextStyle: textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onPrimary,
                  ),
                  selectedDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.onSurface,
                        colorScheme.primary,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    shape: BoxShape.rectangle,
                  ),
                  defaultTextStyle: textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onPrimary,
                  ),
                  defaultDecoration: BoxDecoration(
                    color: colorScheme.primary,
                  ),
                  weekendTextStyle: textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onPrimary,
                  ),
                  rowDecoration: BoxDecoration(
                    color: colorScheme.primary,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onPrimary.withOpacity(0.6429),
                  ),
                  weekendStyle: textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onPrimary.withOpacity(0.6429),
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                  ),
                ),
                rowHeight: 20,
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      _rangeStart = null;
                      _rangeEnd = null;
                      _rangeSelectionMode = RangeSelectionMode.toggledOff;
                    });

                    ctx
                        .read<AppointmentBloc>()
                        .add(AppointmentLoad(_selectedDay!));
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              );
            }),
            const SizedBox(height: 8),
            Text(
              monthCharFormat.format(_selectedDay!),
              style: textTheme.labelSmall!.copyWith(
                color: colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            BlocConsumer<AppointmentBloc, AppointmentState>(
              listener: (ctx, state) {
                switch (state.runtimeType) {
                  case AppointmentRemoving:
                    loadingIndicator.show(
                      context: ctx,
                      height: indicatorHeight,
                    );
                    break;
                  case AppointmentRemoved:
                    loadingIndicator.hide(ctx);
                    Navigator.of(ctx).pop(true);
                    SASnackBar.show(
                      context: ctx,
                      message: l10n.deleteSuccess,
                      isSuccess: true,
                    );
                    ctx.read<AppointmentBloc>().add(
                          AppointmentLoad(_selectedDay!),
                        );
                    break;
                  case AppointmentRemoveError:
                    SASnackBar.show(
                      context: context,
                      message: state.error!,
                      isSuccess: false,
                    );
                    break;
                }
              },
              builder: (ctx, state) {
                if (state is AppointmentLoading) {
                  return SAIndicator(
                    height: indicatorHeight,
                  );
                }

                if (state is AppointmentLoadSuccess &&
                    state.appointments!.isNotEmpty) {
                  final events = state.appointments;
                  final users = state.users;
                  User findUser(String userId) {
                    return users.where((e) => e.id == userId).first;
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: events!.length,
                      itemBuilder: (ctx, index) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: AppointmentCard(
                          name: findUser(events[index].userId).name,
                          avatar: findUser(events[index].userId).avatar,
                          appointment: events[index],
                          onEditPressed: () {
                            if (isLessThan24HoursFromNow(events[index])) {
                              SASnackBar.show(
                                context: context,
                                message: l10n.unableEditError,
                                isSuccess: false,
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: ctx.read<AppointmentBloc>(),
                                    child: NewAppointmentScreen(
                                      appointment: events[index],
                                      user: findUser(events[index].userId),
                                      selectedDay: _selectedDay!,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          onRemovePressed: () {
                            AlertConfirmDialog.show(
                              context: ctx,
                              title: l10n.removeConfirmTitle,
                              message: l10n.removeConfirmMessage,
                              onPressedRight: () {
                                ctx.read<AppointmentBloc>().add(
                                      AppointmentRemovePressed(
                                        appointmentId: events[index].id!,
                                      ),
                                    );
                              },
                              onPressedLeft: () {
                                Navigator.pop(ctx, false);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox(
                  height: indicatorHeight / 2,
                  child: Center(
                    child: Text(
                      l10n.emptyAppointments,
                      style: textTheme.bodyLarge!.copyWith(
                        color: colorScheme.secondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    required this.appointment,
    required this.name,
    required this.avatar,
    required this.onEditPressed,
    required this.onRemovePressed,
    super.key,
  });

  final Appointment appointment;
  final String name;
  final String avatar;
  final VoidCallback onEditPressed;
  final VoidCallback onRemovePressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: false,
      elevation: 2,
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Time(
                  startTime: appointment.startTime,
                  endTime: appointment.endTime,
                ),
                Row(
                  children: [
                    SAButton.icon(
                      onPressed: onEditPressed,
                      child: const SAIcons(
                        icon: Assets.editIcon,
                      ),
                    ),
                    SAButton.icon(
                      onPressed: onRemovePressed,
                      child: const SAIcons(
                        icon: Assets.removeIcon,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 24),
            Customer(
              name: name,
              avatar: avatar,
            ),
            const SizedBox(height: 24),
            Services(
              services: appointment.services,
            ),
            const SizedBox(height: 24),
            Description(
              description: appointment.description,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class Time extends StatelessWidget {
  const Time({
    required this.startTime,
    required this.endTime,
    super.key,
  });

  final DateTime startTime;
  final DateTime endTime;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Row(
      children: [
        SAIcons(
          icon: Assets.scheduleIcon,
          size: 20,
          color: themeData.colorScheme.tertiary,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          '${formatTime(startTime)} - ${formatTime(endTime)}',
          style: themeData.textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class Customer extends StatelessWidget {
  const Customer({
    required this.name,
    required this.avatar,
    super.key,
  });

  final String name;
  final String avatar;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.onPrimary,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(avatar),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          name,
          style: textTheme.bodyLarge!.copyWith(
            color: colorScheme.primary,
          ),
        )
      ],
    );
  }
}

class Services extends StatelessWidget {
  const Services({
    required this.services,
    super.key,
  });

  final String services;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        const SizedBox(
          width: 34,
        ),
        Expanded(
          child: Text(
            services,
            style: textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class Description extends StatelessWidget {
  const Description({
    required this.description,
    super.key,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            description,
            style: textTheme.bodySmall!.copyWith(
              color: colorScheme.onSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
