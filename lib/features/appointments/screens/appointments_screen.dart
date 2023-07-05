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
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 8),
                      blurRadius: 12,
                      spreadRadius: 0,
                      color: colorScheme.primary.withOpacity(0.3219),
                    ),
                  ],
                  shape: BoxShape.rectangle,
                ),
                child: TableCalendar<Appointment>(
                  headerVisible: false,
                  daysOfWeekVisible: false,
                  firstDay: firstDay,
                  lastDay: lastDay,
                  focusedDay: _focusedDay!,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  calendarFormat: CalendarFormat.week,
                  rangeSelectionMode: _rangeSelectionMode,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarBuilders: CalendarBuilders(
                    selectedBuilder: (context, day, focusedDay) {
                      return CalendarCell(
                        dayOfWeek: dayOfWeekFormat.format(day),
                        day: day.day.toString(),
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.onSurface,
                            colorScheme.primary,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      );
                    },
                    defaultBuilder: (context, day, focusedDay) {
                      return CalendarCell(
                        dayOfWeek: dayOfWeekFormat.format(day),
                        day: day.day.toString(),
                      );
                    },
                    todayBuilder: (context, day, focusedDay) {
                      return CalendarCell(
                        dayOfWeek: dayOfWeekFormat.format(day),
                        day: day.day.toString(),
                      );
                    },
                    outsideBuilder: (context, day, focusedDay) {
                      return CalendarCell(
                        dayOfWeek: dayOfWeekFormat.format(day),
                        day: day.day.toString(),
                        bgColor: colorScheme.primary,
                      );
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: true,
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
                    outsideTextStyle: textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onPrimary,
                    ),
                    rowDecoration: BoxDecoration(
                      color: colorScheme.primary,
                    ),
                  ),
                  rowHeight: 44,
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
                ),
              );
            }),
            const SizedBox(height: 10),
            Text(
              monthCharFormat.format(_selectedDay!),
              style: textTheme.labelSmall!.copyWith(
                color: colorScheme.secondary,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.24,
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
                switch (state.runtimeType) {
                  case AppointmentLoading:
                    return SAIndicator(
                      height: indicatorHeight,
                    );
                  case AppointmentLoadSuccess:
                    final events =
                        groupByDate(state.appointments!, _selectedDay!);
                    if (events.isNotEmpty) {
                      final users = state.users;
                      User findUser(String userId) =>
                          users.where((e) => e.id == userId).first;

                      return Expanded(
                        child: Container(
                          color: colorScheme.tertiaryContainer,
                          child: ListView.builder(
                            itemCount: events.length,
                            itemBuilder: (ctx, index) => AppointmentCard(
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
                    } else {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: indicatorHeight,
                        ),
                        child: Center(
                          child: Text(
                            l10n.emptyAppointments,
                            style: textTheme.bodyLarge!.copyWith(
                              color: colorScheme.secondary,
                            ),
                          ),
                        ),
                      );
                    }
                }
                return Container();
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
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.16),
      margin: const EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 12,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Time(
                  startTime: appointment.startTime,
                  endTime: appointment.endTime,
                  text: S.of(context).beautySalonText,
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
            const SizedBox(height: 12),
            Customer(
              name: name,
              avatar: avatar,
            ),
            const SizedBox(height: 12),
            Services(
              services: appointment.services,
            ),
            const SizedBox(height: 12),
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
    required this.text,
    super.key,
  });

  final DateTime startTime;
  final DateTime endTime;
  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SAIcons(
              icon: Assets.scheduleIcon,
              size: 20,
              color: themeData.colorScheme.tertiary,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              '${formatTime(startTime)} - ${formatTime(endTime)}',
              style: themeData.textTheme.bodyLarge!.copyWith(
                height: 24 / 14,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 32,
            ),
            Text(
              text,
              style: themeData.textTheme.bodySmall!.copyWith(
                color: themeData.colorScheme.onSecondary,
              ),
            ),
          ],
        )
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
          width: 12,
        ),
        Text(
          name,
          style: textTheme.bodyLarge!.copyWith(
            color: colorScheme.primary,
            height: 24 / 14,
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return IntrinsicHeight(
      child: Row(
        children: [
          const SizedBox(
            width: 1,
          ),
          VerticalDivider(
            color: colorScheme.onSecondary,
            thickness: 1,
          ),
          const SizedBox(
            width: 13,
          ),
          Expanded(
            child: Text(
              services,
              style: textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w500,
                height: 20 / 14,
              ),
            ),
          ),
        ],
      ),
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
            maxLines: 3,
            textAlign: TextAlign.justify,
            style: textTheme.bodySmall!.copyWith(
              color: colorScheme.onSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class CalendarCell extends StatelessWidget {
  const CalendarCell({
    required this.dayOfWeek,
    required this.day,
    this.dayOfWeekColor,
    this.dayColor,
    this.bgColor,
    this.gradient,
    super.key,
  });

  final Color? dayOfWeekColor;
  final Color? dayColor;
  final Color? bgColor;
  final Gradient? gradient;
  final String dayOfWeek;
  final String day;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        gradient: gradient,
        shape: BoxShape.rectangle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SAText.weekCalendarCell(
            text: dayOfWeek,
            color: dayOfWeekColor ?? colorScheme.onPrimary.withOpacity(0.6429),
          ),
          SAText.weekCalendarCell(
            text: day,
            color: dayColor ?? colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }
}
