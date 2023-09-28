import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/generated/l10n.dart';
import '../../../../core/layouts/main_layout.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/common.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/model/user.dart';
import '../../../auth/repository/user_repository.dart';
import '../../model/appointment.dart';
import '../../repository/appointment_repository.dart';
import '../appointment_form.dart';
import 'bloc/appointment_bloc.dart';
import 'ui/appointment_ui.dart';

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
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final ColorScheme colorScheme = themeData.colorScheme;
    final double indicatorHeight = MediaQuery.of(context).size.height / 2;
    final l10n = S.of(context);

    return RepositoryProvider(
      create: (context) => AppointmentRepository(),
      child: BlocProvider<AppointmentBloc>(
        create: (context) => AppointmentBloc(
          appointmentRepository: context.read<AppointmentRepository>(),
          userRepository: context.read<UserRepository>(),
        )..add(
            AppointmentLoaded(
              focusedDay: widget.focusedDay,
            ),
          ),
        child: BlocBuilder<AppointmentBloc, AppointmentState>(
          builder: (context, state) {
            return MainLayout(
              currentIndex: 0,
              selectedDay: state.selectedDay!,
              title: l10n.appointmentAppBarTitle,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 8),
                          blurRadius: 12,
                          spreadRadius: 0,
                          color: colorScheme.primary.withOpacity(
                            themeData.calendarShadowOpacity,
                          ),
                          blurStyle: BlurStyle.outer,
                        ),
                      ],
                      shape: BoxShape.rectangle,
                      color: colorScheme.surface,
                    ),
                    child: TableCalendar<Appointment>(
                      headerVisible: false,
                      daysOfWeekVisible: false,
                      firstDay: firstDay,
                      lastDay: lastDay,
                      focusedDay: state.focusedDay!,
                      selectedDayPredicate: (day) => isSameDay(
                        state.selectedDay,
                        day,
                      ),
                      calendarFormat: CalendarFormat.week,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      calendarBuilders: CalendarBuilders(
                        selectedBuilder: (context, day, focusedDay) {
                          return CalendarCell(
                            day: day,
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.secondary,
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
                        context.read<AppointmentBloc>().add(
                              AppointmentCalendarDaySelected(
                                focusedDay: focusedDay,
                                selectedDay: selectedDay,
                              ),
                            );
                      },
                      onPageChanged: (focusedDay) {
                        context.read<AppointmentBloc>().add(
                              AppointmentCalendarPageChanged(
                                focusedDay: focusedDay,
                              ),
                            );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                          blurStyle: BlurStyle.outer,
                          spreadRadius: 0,
                          color: colorScheme.shadow,
                        ),
                      ],
                    ),
                    width: double.infinity,
                    child: Text(
                      monthCharFormat.format(state.selectedDay!),
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium!.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  BlocConsumer<AppointmentBloc, AppointmentState>(
                    listener: (ctx, state) {
                      switch (state.status) {
                        case Status.removeInProgress:
                          loadingIndicator.show(
                            context: ctx,
                            height: indicatorHeight,
                          );
                          break;
                        case Status.removeSuccess:
                          loadingIndicator.hide(ctx);
                          SASnackBar.show(
                            context: ctx,
                            message: l10n.deleteSuccess,
                            isSuccess: true,
                          );

                          Navigator.pop(ctx, false);

                          ctx
                              .read<AppointmentBloc>()
                              .add(const AppointmentLoaded());
                          break;
                        case Status.removeFailure:
                          SASnackBar.show(
                            context: context,
                            message: state.error!,
                            isSuccess: false,
                          );
                          break;
                        default:
                          break;
                      }
                    },
                    builder: (ctx, state) {
                      switch (state.status) {
                        case Status.loadInProgress:
                          return SAIndicator(
                            height: indicatorHeight,
                            color: colorScheme.primary,
                          );
                        case Status.loadSuccess:
                          final events = groupByDate(
                            state.appointments,
                            state.selectedDay!,
                          );

                          if (events.isNotEmpty) {
                            return Expanded(
                              child: ListView.builder(
                                itemCount: events.length,
                                itemBuilder: (ctx, index) {
                                  final user = findUser(
                                    state.users,
                                    events[index].userId,
                                  );

                                  return AppointmentCard(
                                    key:
                                        Key('appointment_${events[index].id!}'),
                                    name: user.name,
                                    avatar: user.avatar,
                                    appointment: events[index],
                                    onEditPressed: () {
                                      if (isCurrentDay(events[index])) {
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
                                              value:
                                                  ctx.read<AppointmentBloc>(),
                                              child: AppointmentForm(
                                                appointment: events[index],
                                                user: user,
                                                selectedDay: state.selectedDay!,
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
                                                  appointmentId:
                                                      events[index].id!,
                                                ),
                                              );
                                        },
                                        onPressedLeft: () {
                                          Navigator.pop(ctx, false);
                                        },
                                      );
                                    },
                                  );
                                },
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
                        case Status.loadFailure:
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

  User findUser(
    List<User> users,
    String userId,
  ) {
    return users.where((e) => e.id == userId).first;
  }
}
