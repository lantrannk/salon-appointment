import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/constants/constants.dart';
import '../../../core/generated/l10n.dart';
import '../../../core/layouts/main_layout.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/common.dart';
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
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final ColorScheme colorScheme = themeData.colorScheme;
    final double indicatorHeight = MediaQuery.of(context).size.height / 4;
    final l10n = S.of(context);

    return RepositoryProvider(
      create: (context) => AppointmentRepository(),
      child: BlocProvider<AppointmentBloc>(
        create: (context) => AppointmentBloc(
          appointmentRepository: context.read<AppointmentRepository>(),
          userRepository: context.read<UserRepository>(),
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
                          bgColor: colorScheme.primary.withOpacity(
                            themeData.todayBackgroundOpacity,
                          ),
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
                          iconColor: colorScheme.primary.withOpacity(
                            themeData.calendarCellTextOpacity,
                          ),
                          dayColor: colorScheme.primaryContainer,
                          timeColor: colorScheme.primaryContainer,
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
                              colorScheme.secondary,
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
                          color: colorScheme.surface,
                          child: SAText.weekCalendarCell(
                            text: dayOfWeekFormat.format(day),
                            color: colorScheme.onSurface,
                          ),
                        );
                      },
                    ),
                    calendarStyle: const CalendarStyle(
                      outsideDaysVisible: true,
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
                      return Expanded(
                        child: SAIndicator(
                          height: indicatorHeight,
                          color: colorScheme.primary,
                        ),
                      );
                    case AppointmentLoadSuccess:
                      final List<Appointment> events = groupByDate(
                        state.appointments!,
                        _selectedDay!,
                      );

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
                                      colorScheme.secondary,
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
                              style: textTheme.bodyLarge,
                            ),
                          ),
                        );
                      }
                    case AppointmentLoadFailure:
                      return Expanded(
                        child: Center(
                          child: Text(
                            state.error!,
                            style: textTheme.bodyLarge,
                          ),
                        ),
                      );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
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
          color: themeData.colorScheme.onPrimary.withOpacity(
            themeData.chevronTextOpacity,
          ),
        ),
      ),
    );
  }
}
