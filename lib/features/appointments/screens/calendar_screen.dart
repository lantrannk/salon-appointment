import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/constants/assets.dart';
import '../../../core/constants/date_format.dart';
import '../../../core/generated/l10n.dart';
import '../../../core/layouts/main_layout.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/widgets.dart';
import '../bloc/appointment_bloc.dart';
import '../model/appointment.dart';
import '../repository/appointment_repository.dart';
import '../screens/appointments_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final appointmentRepo = AppointmentRepository();

  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double indicatorHeight = MediaQuery.of(context).size.height / 4;
    final l10n = S.of(context);

    return BlocProvider<AppointmentBloc>(
      create: (context) =>
          AppointmentBloc()..add(AppointmentLoad(_selectedDay!)),
      child: MainLayout(
        currentIndex: 1,
        selectedDay: _selectedDay!,
        title: l10n.calendarAppBarTitle,
        child: Column(
          children: [
            BlocBuilder<AppointmentBloc, AppointmentState>(
              builder: (context, state) {
                return TableCalendar<Appointment>(
                  firstDay: firstDay,
                  lastDay: lastDay,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: _rangeSelectionMode,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarBuilders: CalendarBuilders(
                    todayBuilder: (context, day, focusedDay) {
                      final String text = day.day.toString();
                      final events = groupByDate(state.appointments!, day);
                      return MonthCalendarCell(
                        text: text,
                        events: events,
                        bgColor: colorScheme.primary.withOpacity(0.0798),
                      );
                    },
                    defaultBuilder: (context, day, focusedDay) {
                      final String text = day.day.toString();
                      final events = groupByDate(state.appointments!, day);

                      return MonthCalendarCell(
                        text: text,
                        events: events,
                      );
                    },
                    outsideBuilder: (context, day, focusedDay) {
                      final String text = day.day.toString();
                      final events = groupByDate(state.appointments!, day);

                      return MonthCalendarCell(
                        text: text,
                        events: events,
                        dayColor: colorScheme.onSecondary,
                      );
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      final String text = day.day.toString();
                      final events = groupByDate(state.appointments!, day);

                      return MonthCalendarCell(
                        text: text,
                        events: events,
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.onSurface,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        dayColor: colorScheme.onPrimary,
                        timeColor: colorScheme.onPrimary,
                      );
                    },
                    dowBuilder: (context, day) {
                      return Container(
                        alignment: Alignment.centerRight,
                        child: SAText.weekCalendarCell(
                          text: dayOfWeekFormat.format(day),
                          color: colorScheme.secondary,
                        ),
                      );
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: true,
                    rowDecoration: BoxDecoration(
                      border: Border.all(
                        color: colorScheme.surface,
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    headerPadding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                    ),
                    leftChevronIcon: CalendarChevronText(
                      focusedDay: DateTime(
                        _focusedDay.year,
                        _focusedDay.month - 1,
                        _focusedDay.day,
                      ),
                    ),
                    rightChevronIcon: CalendarChevronText(
                      focusedDay: DateTime(
                        _focusedDay.year,
                        _focusedDay.month + 1,
                        _focusedDay.day,
                      ),
                    ),
                    titleTextStyle: textTheme.bodyMedium!.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  daysOfWeekHeight: 44,
                  rowHeight: 56,
                  pageJumpingEnabled: true,
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _rangeStart = null;
                        _rangeEnd = null;
                        _rangeSelectionMode = RangeSelectionMode.toggledOff;
                      });
                    }
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = DateTime(
                        focusedDay.year,
                        focusedDay.month,
                        _focusedDay.day,
                      );
                      _selectedDay = _focusedDay;
                    });

                    context
                        .read<AppointmentBloc>()
                        .add(AppointmentLoad(_selectedDay!));
                  },
                );
              },
            ),
            BlocBuilder<AppointmentBloc, AppointmentState>(
              builder: (context, state) {
                switch (state.runtimeType) {
                  case AppointmentLoading:
                    return SAIndicator(
                      height: indicatorHeight,
                    );
                  case AppointmentLoadSuccess:
                    final List<Appointment> events =
                        groupByDate(state.appointments!, _selectedDay!);
                    return (events.isNotEmpty)
                        ? Container(
                            margin: const EdgeInsets.only(top: 8),
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
                            height: 228,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.primary,
                                  colorScheme.onSurface,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: CalendarSchedule(
                              appointment: events.first,
                              countOfAppointments: events.length,
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AppointmentScreen(
                                      focusedDay: _selectedDay,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : SizedBox(
                            height: indicatorHeight,
                            child: Center(
                              child: Text(
                                l10n.emptyAppointments,
                                style: textTheme.bodyLarge!.copyWith(
                                  color: colorScheme.secondary,
                                ),
                              ),
                            ),
                          );
                  case AppointmentLoadError:
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: indicatorHeight,
                      ),
                      child: Center(
                        child: Text(
                          state.error!,
                          style: textTheme.bodyLarge!.copyWith(
                            color: colorScheme.secondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
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

class CalendarChevronText extends StatelessWidget {
  const CalendarChevronText({
    required this.focusedDay,
    super.key,
  });

  final DateTime focusedDay;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Text(
      calendarTitleFormat.format(focusedDay),
      style: themeData.textTheme.bodyMedium!.copyWith(
        color: themeData.colorScheme.onPrimary.withOpacity(0.3991),
      ),
    );
  }
}

class CalendarSchedule extends StatelessWidget {
  const CalendarSchedule({
    required this.appointment,
    required this.countOfAppointments,
    this.onPressed,
    super.key,
  });

  final Appointment appointment;
  final int countOfAppointments;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 26,
            left: 27,
          ),
          child: SAIcons(
            icon: Assets.scheduleIcon,
            size: 20,
            color: colorScheme.onPrimary,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 22),
                SAText.calendarSchedule(
                  text: monthCharFormat.format(appointment.date),
                  style: textTheme.labelLarge!,
                ),
                const SizedBox(height: 7),
                SAText.calendarSchedule(
                  text:
                      '${formatTime(appointment.startTime)} - ${formatTime(appointment.endTime)}',
                  style: textTheme.bodyLarge!.copyWith(
                    height: 24 / 14,
                  ),
                ),
                const SizedBox(height: 12),
                SAText.calendarSchedule(
                  text: appointment.description,
                  style: textTheme.bodySmall!,
                  maxLines: 5,
                ),
                const Spacer(),
                SAButton.text(
                  onPressed: onPressed,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: SAText.calendarSchedule(
                      text: 'Show appointments ($countOfAppointments)',
                      style: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MonthCalendarCell extends StatelessWidget {
  const MonthCalendarCell({
    required this.text,
    required this.events,
    this.dayColor,
    this.timeColor,
    this.bgColor,
    this.gradient,
    super.key,
  });

  final String text;
  final List<Appointment> events;
  final Color? dayColor;
  final Color? timeColor;
  final Color? bgColor;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        gradient: gradient,
        shape: BoxShape.rectangle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // SAIcons(
              //   icon: Assets.breakIcon,
              //   color: colorScheme.primary,
              //   size: 12,
              // ),
              const SizedBox(width: 12),
              Flexible(
                child: SizedBox(
                  width: 15,
                  child: Text(
                    text,
                    style: textTheme.bodySmall!.copyWith(
                      height: 18 / 12,
                      color: dayColor ?? colorScheme.secondary,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 2,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (int i = 0; i < events.length && i < 2; i++)
                SAText.timeCell(
                  text: timeFormat.format(events[i].startTime),
                  color: timeColor ?? colorScheme.onSecondary,
                ),
            ],
          )
        ],
      ),
    );
  }
}
