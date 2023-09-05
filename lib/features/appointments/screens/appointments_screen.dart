import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

import '../../../core/constants/constants.dart';
import '../../../core/generated/l10n.dart';
import '../../../core/layouts/main_layout.dart';
import '../../../core/utils/common.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/model/user.dart';
import '../../auth/repository/user_repository.dart';
import '../api/appointment_api.dart';
import '../bloc/appointment_bloc.dart';
import '../model/appointment.dart';
import '../repository/appointment_repository.dart';
import 'appointments_widgets/appointments_widgets.dart';
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
  final appointmentApi = AppointmentApi(http.Client());
  final appointmentRepo = AppointmentRepository();
  final userRepo = UserRepository();

  DateTime? _focusedDay;
  DateTime? _selectedDay;

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
      create: (_) => AppointmentBloc(
        appointmentApi: appointmentApi,
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      )..add(AppointmentLoad()),
      child: MainLayout(
        currentIndex: 0,
        selectedDay: _selectedDay!,
        title: l10n.appointmentAppBarTitle,
        child: Column(
          children: [
            BlocBuilder<AppointmentBloc, AppointmentState>(
              builder: (ctx, state) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
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
                    calendarFormat: CalendarFormat.week,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    calendarBuilders: CalendarBuilders(
                      selectedBuilder: (context, day, focusedDay) {
                        return CalendarCell(
                          day: day,
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
                      defaultBuilder: (context, day, focusedDay) =>
                          CalendarCell(day: day),
                      todayBuilder: (context, day, focusedDay) =>
                          CalendarCell(day: day),
                      outsideBuilder: (context, day, focusedDay) =>
                          CalendarCell(day: day),
                    ),
                    calendarStyle: const CalendarStyle(
                      outsideDaysVisible: true,
                    ),
                    rowHeight: 44,
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
                        _focusedDay = focusedDay;
                        _selectedDay = focusedDay;
                      });
                    },
                  ),
                );
              },
            ),
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
                  case AppointmentRemoveInProgress:
                    loadingIndicator.show(
                      context: ctx,
                      height: indicatorHeight,
                    );
                    break;
                  case AppointmentRemoveSuccess:
                    loadingIndicator.hide(ctx);
                    Navigator.of(ctx).pop(true);
                    SASnackBar.show(
                      context: ctx,
                      message: l10n.deleteSuccess,
                      isSuccess: true,
                    );
                    ctx.read<AppointmentBloc>().add(
                          AppointmentLoad(),
                        );
                    break;
                  case AppointmentRemoveFailure:
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
                  case AppointmentLoadInProgress:
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
                              key: Key('appointment_${events[index].id!}'),
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
                                  content: l10n.removeConfirmMessage,
                                  onPressedRight: () {
                                    ctx.read<AppointmentBloc>().add(
                                          AppointmentRemoved(
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
