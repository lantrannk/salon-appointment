import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/generated/l10n.dart';
import '../../../../core/layouts/main_layout.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/common.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/repository/user_repository.dart';
import '../../model/appointment.dart';
import '../../repository/appointment_repository.dart';
import '../appointment/appointments_screen.dart';
import 'bloc/calendar_bloc.dart';
import 'ui/calendar_ui.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final ColorScheme colorScheme = themeData.colorScheme;
    final double indicatorHeight = MediaQuery.of(context).size.height / 4;
    final l10n = S.of(context);

    return RepositoryProvider(
      create: (context) => AppointmentRepository(),
      child: BlocProvider<CalendarBloc>(
        create: (context) => CalendarBloc(
          appointmentRepository: context.read<AppointmentRepository>(),
          userRepository: context.read<UserRepository>(),
        )..add(const CalendarAppointmentLoaded()),
        child: BlocBuilder<CalendarBloc, CalendarState>(
          builder: (context, state) {
            return MainLayout(
              currentIndex: 1,
              selectedDay: state.selectedDay,
              title: l10n.calendarAppBarTitle,
              child: Column(
                children: [
                  TableCalendar<Appointment>(
                    firstDay: firstDay,
                    lastDay: lastDay,
                    focusedDay: state.focusedDay,
                    selectedDayPredicate: (day) => isSameDay(
                      state.selectedDay,
                      day,
                    ),
                    calendarFormat: CalendarFormat.month,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, _) {
                        final events = groupByDate(state.appointments, day);
                        return (events.isNotEmpty)
                            ? isSameDay(day, state.selectedDay)
                                ? CalendarMarker(
                                    events: events,
                                    iconColor: colorScheme.onPrimary,
                                    timeColor: colorScheme.onPrimary,
                                  )
                                : CalendarMarker(
                                    events: events,
                                    iconColor: colorScheme.primary,
                                    timeColor: colorScheme.primaryContainer,
                                  )
                            : null;
                      },
                      todayBuilder: (context, day, _) {
                        return MonthCalendarCell(
                          day: day,
                          bgColor: colorScheme.primary.withOpacity(
                            themeData.todayBackgroundOpacity,
                          ),
                        );
                      },
                      defaultBuilder: (context, day, _) {
                        return MonthCalendarCell(
                          day: day,
                        );
                      },
                      outsideBuilder: (context, day, _) {
                        return MonthCalendarCell(
                          day: day,
                          iconColor: colorScheme.primary.withOpacity(
                            themeData.calendarCellTextOpacity,
                          ),
                          dayColor: colorScheme.primaryContainer,
                        );
                      },
                      selectedBuilder: (context, day, _) {
                        return MonthCalendarCell(
                          day: day,
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary,
                              colorScheme.secondary,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          dayColor: colorScheme.onPrimary,
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
                      headerPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                      ),
                      leftChevronPadding: context.padding(
                        left: 12,
                      ),
                      rightChevronPadding: context.padding(
                        right: 12,
                      ),
                      leftChevronMargin: EdgeInsets.zero,
                      rightChevronMargin: EdgeInsets.zero,
                      leftChevronIcon: CalendarChevronText(
                        focusedDay: DateTime(
                          state.focusedDay.year,
                          state.focusedDay.month - 1,
                          state.focusedDay.day,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      rightChevronIcon: CalendarChevronText(
                        focusedDay: DateTime(
                          state.focusedDay.year,
                          state.focusedDay.month + 1,
                          state.focusedDay.day,
                        ),
                        textAlign: TextAlign.end,
                      ),
                      titleTextStyle: textTheme.bodyMedium!.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    daysOfWeekHeight: context.getHeight(44),
                    rowHeight: context.getHeight(52),
                    pageJumpingEnabled: true,
                    onDaySelected: (selectedDay, focusedDay) {
                      context.read<CalendarBloc>().add(
                            CalendarDaySelected(
                              focusedDay: focusedDay,
                              selectedDay: selectedDay,
                            ),
                          );
                    },
                    onPageChanged: (focusedDay) {
                      context.read<CalendarBloc>().add(
                            CalendarPageChanged(
                              focusedDay: DateTime(
                                focusedDay.year,
                                focusedDay.month,
                                state.focusedDay.day,
                              ),
                            ),
                          );
                    },
                  ),
                  BlocBuilder<CalendarBloc, CalendarState>(
                    builder: (context, state) {
                      switch (state.status) {
                        case LoadStatus.loadInProgress:
                          return Expanded(
                            child: SAIndicator(
                              height: indicatorHeight,
                              color: colorScheme.primary,
                            ),
                          );
                        case LoadStatus.loadSuccess:
                          final List<Appointment> events = groupByDate(
                            state.appointments,
                            state.selectedDay,
                          );

                          if (events.isEmpty) {
                            return Expanded(
                              child: Center(
                                child: Text(
                                  l10n.emptyAppointments,
                                  style: textTheme.bodyLarge,
                                ),
                              ),
                            );
                          } else {
                            return AppointmentOverview(
                              child: CalendarSchedule(
                                appointment: events.first,
                                countOfAppointments: events.length,
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AppointmentScreen(
                                        focusedDay: state.selectedDay,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        case LoadStatus.loadFailure:
                          return Expanded(
                            child: Center(
                              child: Text(
                                state.error!,
                                style: textTheme.bodyLarge,
                              ),
                            ),
                          );
                        default:
                          return const SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
