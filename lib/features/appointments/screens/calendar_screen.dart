import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/constants/date_format.dart';
import '../../../core/generated/l10n.dart';
import '../../../core/layouts/main_layout.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/repository/user_repository.dart';
import '../bloc/appointment_bloc.dart';
import '../model/appointment.dart';
import '../repository/appointment_repository.dart';
import '../screens/appointments_screen.dart';
import 'appointments_widgets/appointments_widgets.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final appointmentRepo = AppointmentRepository();
  final userRepo = UserRepository();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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
      create: (_) => AppointmentBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      )..add(AppointmentLoad()),
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
                  calendarFormat: CalendarFormat.month,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarBuilders: CalendarBuilders(
                    todayBuilder: (context, day, focusedDay) {
                      final events = groupByDate(state.appointments!, day);
                      return MonthCalendarCell(
                        day: day,
                        events: events,
                        bgColor: colorScheme.primary.withOpacity(0.0798),
                      );
                    },
                    defaultBuilder: (context, day, focusedDay) {
                      final events = groupByDate(state.appointments!, day);

                      return MonthCalendarCell(
                        day: day,
                        events: events,
                      );
                    },
                    outsideBuilder: (context, day, focusedDay) {
                      final events = groupByDate(state.appointments!, day);

                      return MonthCalendarCell(
                        day: day,
                        events: events,
                        dayColor: colorScheme.onSecondary,
                      );
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      final events = groupByDate(state.appointments!, day);

                      return MonthCalendarCell(
                        day: day,
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
                        iconColor: colorScheme.onPrimary,
                      );
                    },
                    dowBuilder: (context, day) {
                      return Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
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
                      textAlign: TextAlign.start,
                    ),
                    rightChevronIcon: CalendarChevronText(
                      focusedDay: DateTime(
                        _focusedDay.year,
                        _focusedDay.month + 1,
                        _focusedDay.day,
                      ),
                      textAlign: TextAlign.end,
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
                  },
                );
              },
            ),
            BlocBuilder<AppointmentBloc, AppointmentState>(
              builder: (context, state) {
                switch (state.runtimeType) {
                  case AppointmentLoadInProgress:
                    return SAIndicator(
                      height: indicatorHeight,
                    );
                  case AppointmentLoadSuccess:
                    final List<Appointment> events =
                        groupByDate(state.appointments!, _selectedDay!);
                    if (events.isNotEmpty) {
                      return Expanded(
                        child: ListView(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              alignment: Alignment.topLeft,
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
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Expanded(
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
                  case AppointmentLoadFailure:
                    return Expanded(
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
    required this.textAlign,
    super.key,
  });

  final DateTime focusedDay;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return SizedBox(
      width: 110,
      child: Text(
        calendarTitleFormat.format(focusedDay),
        textAlign: textAlign,
        style: themeData.textTheme.bodyMedium!.copyWith(
          color: themeData.colorScheme.onPrimary.withOpacity(0.3991),
        ),
      ),
    );
  }
}
