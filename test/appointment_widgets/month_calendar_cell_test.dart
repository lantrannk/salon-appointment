import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/generated/l10n.dart';
import 'package:salon_appointment/features/appointments/bloc/appointment_bloc.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';
import 'package:salon_appointment/features/appointments/screens/appointments_widgets/appointments_widgets.dart';
import 'package:salon_appointment/features/appointments/screens/calendar_screen.dart';

import 'package:salon_appointment/features/auth/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAppointmentBloc extends Mock implements AppointmentBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late AppointmentBloc appointmentBloc;
  late Widget calendarScreen;
  late List<AppointmentState> expectedStates;

  final List<User> users = [
    {
      'phoneNumber': '0794542105',
      'name': 'Lan Tran',
      'avatar':
          'https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg',
      'password': '123456',
      'isAdmin': true,
      'id': '1'
    },
    {
      'phoneNumber': '0905999222',
      'name': 'Carol Williams',
      'avatar':
          'https://assets.vogue.in/photos/611cf20c8733032148fe1b06/2:3/w_2560%2Cc_limit/Slide%25201.jpg',
      'password': '123456',
      'isAdmin': false,
      'id': '2'
    },
    {
      'phoneNumber': '0934125689',
      'name': 'Hailee Steinfeld',
      'avatar':
          'https://glints.com/vn/blog/wp-content/uploads/2022/08/co%CC%82ng-vie%CC%A3%CC%82c-beauty-blogger-819x1024.jpg',
      'password': '123456',
      'isAdmin': false,
      'id': '3'
    },
    {
      'phoneNumber': '0902335577',
      'name': 'Ruby Nguyen',
      'avatar':
          'https://studiochupanhdep.com//Upload/Images/Album/anh-beauty-11.jpg',
      'password': '123456',
      'isAdmin': false,
      'id': '4'
    },
    {
      'phoneNumber': '070456123',
      'name': 'Elizabeth Taylor',
      'avatar':
          'https://www.m1-beauty.de/assets/images/f/Ronja_VorherNachher_45Grad_2-c7cc48ca.jpg',
      'password': '123456',
      'isAdmin': false,
      'id': '3'
    }
  ].map((e) => User.fromJson(e)).toList();

  final List<Appointment> appointments = [
    {
      'date': '2023-05-12T00:00:00.000',
      'startTime': '2023-05-12T18:00:00.000',
      'endTime': '2023-05-12T18:30:00.000',
      'userId': '2',
      'services': 'Neck & Shoulders',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '7'
    },
    {
      'date': '2023-05-23T00:00:00.000',
      'startTime': '2023-05-23T16:35:00.000',
      'endTime': '2023-05-23T17:05:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '6'
    },
    {
      'date': '2023-05-23T00:00:00.000',
      'startTime': '2023-05-23T18:00:00.000',
      'endTime': '2023-05-23T18:30:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '7'
    },
    {
      'date': '2023-05-22T18:03:33.900524',
      'startTime': '2023-05-22T20:03:00.000',
      'endTime': '2023-05-22T20:33:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '9'
    },
    {
      'date': '2023-05-24T00:00:00.000',
      'startTime': '2023-05-24T18:19:00.000',
      'endTime': '2023-05-24T18:49:00.000',
      'userId': '1',
      'services': 'Back',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '12'
    },
    {
      'date': '2023-05-24T00:00:00.000',
      'startTime': '2023-05-24T18:30:00.000',
      'endTime': '2023-05-24T19:00:00.000',
      'userId': '1',
      'services': 'Neck & Shoulders',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '20'
    },
    {
      'date': '2023-06-29T00:00:00.000',
      'startTime': '2023-06-29T11:00:00.000',
      'endTime': '2023-06-29T11:30:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '25'
    },
    {
      'date': '2023-06-23T17:44:05.534356',
      'startTime': '2023-06-23T18:00:00.000',
      'endTime': '2023-06-23T18:30:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '32'
    },
    {
      'date': '2023-07-01T00:00:00.000',
      'startTime': '2023-07-01T09:45:00.000',
      'endTime': '2023-07-01T10:15:00.000',
      'userId': '1',
      'services': 'Back',
      'description':
          'There is a distinction between a beauty salon and a hair salon and although many small businesses do offer both sets of treatments; beauty salons provide extended services related to skin health, facial aesthetic, foot care, nail manicures, aromatherapy — even meditation, oxygen therapy, mud baths and many other services.',
      'isCompleted': false,
      'id': '57'
    },
    {
      'date': '2023-07-02T00:00:00.000',
      'startTime': '2023-07-02T16:00:00.000',
      'endTime': '2023-07-02T16:30:00.000',
      'userId': '1',
      'services': 'Neck & Shoulders',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '60'
    },
    {
      'date': '2023-07-03T00:00:00.000',
      'startTime': '2023-07-03T20:00:00.000',
      'endTime': '2023-07-03T20:30:00.000',
      'userId': '2',
      'services': 'Neck & Shoulders',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '63'
    },
    {
      'date': '2023-07-03T11:48:00.000',
      'startTime': '2023-07-03T09:30:00.000',
      'endTime': '2023-07-03T10:00:00.000',
      'userId': '2',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '64'
    },
    {
      'date': '2023-06-28T17:55:00.000',
      'startTime': '2023-06-28T20:30:00.000',
      'endTime': '2023-06-28T21:00:00.000',
      'userId': '1',
      'services': 'Back',
      'description':
          'There is a distinction between a beauty salon and a hair salon and although many small businesses do offer both sets of treatments; beauty salons provide extended services related to skin health, facial aesthetic, foot care, nail manicures, aromatherapy — even meditation, oxygen therapy, mud baths and many other services.',
      'isCompleted': false,
      'id': '66'
    },
    {
      'date': '2023-06-30T00:00:00.000',
      'startTime': '2023-06-30T11:00:00.000',
      'endTime': '2023-06-30T11:30:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '67'
    },
    {
      'date': '2023-06-30T11:29:00.000',
      'startTime': '2023-06-30T11:30:00.000',
      'endTime': '2023-06-30T12:00:00.000',
      'userId': '1',
      'services': 'Neck & Shoulders',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '68'
    },
    {
      'date': '2023-06-30T00:00:00.000',
      'startTime': '2023-06-30T20:00:00.000',
      'endTime': '2023-06-30T20:30:00.000',
      'userId': '1',
      'services': 'Back',
      'description': 'Test BLoC',
      'isCompleted': false,
      'id': '69'
    },
    {
      'date': '2023-06-29T17:29:00.000',
      'startTime': '2023-06-29T18:00:00.000',
      'endTime': '2023-06-29T18:30:00.000',
      'userId': '1',
      'services': 'Back',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '70'
    },
    {
      'date': '2023-07-11T00:00:00.000',
      'startTime': '2023-07-11T09:00:00.000',
      'endTime': '2023-07-11T09:30:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description':
          'There is a distinction between a beauty salon and a hair salon and although many small businesses do offer both sets of treatments; beauty salons provide extended services related to skin health, facial aesthetic, foot care, nail manicures, aromatherapy — even meditation, oxygen therapy, mud baths and many other services.',
      'isCompleted': false,
      'id': '72'
    },
    {
      'date': '2023-07-08T00:00:00.000',
      'startTime': '2023-07-08T08:30:00.000',
      'endTime': '2023-07-08T09:00:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '74'
    },
    {
      'date': '2023-07-07T00:00:00.000',
      'startTime': '2023-07-07T08:42:00.000',
      'endTime': '2023-07-07T09:12:00.000',
      'userId': '1',
      'services': 'Back',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '75'
    },
    {
      'date': '2023-07-07T08:43:00.000',
      'startTime': '2023-07-07T18:00:00.000',
      'endTime': '2023-07-07T18:30:00.000',
      'userId': '1',
      'services': 'Back',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '76'
    },
    {
      'date': '2023-07-21T10:55:00.000',
      'startTime': '2023-07-21T18:00:00.000',
      'endTime': '2023-07-21T18:30:00.000',
      'userId': '2',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '78'
    },
    {
      'date': '2023-08-15T10:55:00.000',
      'startTime': '2023-08-15T18:00:00.000',
      'endTime': '2023-08-15T18:30:00.000',
      'userId': '2',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '79'
    },
    {
      'date': '2023-08-15T10:55:00.000',
      'startTime': '2023-08-15T20:00:00.000',
      'endTime': '2023-08-15T20:30:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '80'
    },
    {
      'date': '2023-08-15T10:55:00.000',
      'startTime': '2023-08-15T19:00:00.000',
      'endTime': '2023-08-15T19:30:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '82'
    }
  ].map((e) => Appointment.fromJson(e)).toList();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    appointmentBloc = MockAppointmentBloc();
    calendarScreen = MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: BlocProvider.value(
          value: appointmentBloc,
          child: const CalendarScreen(),
        ),
      ),
    );

    expectedStates = [
      AppointmentLoading(),
      AppointmentLoadSuccess(
        users: users,
        appointments: appointments,
      ),
    ];
    whenListen(
      appointmentBloc,
      Stream.fromIterable(expectedStates),
      initialState: AppointmentLoading(),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user',
        '{"phoneNumber":"0794542105","name":"Lan Tran","avatar":"https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg","password":"123456","isAdmin":true,"id":"1"}');
  });

  testWidgets(
    'Selected day cell has gradient color',
    (tester) async {
      final nowFinder = find.widgetWithText(
        MonthCalendarCell,
        DateTime.now().day.toString(),
      );

      await tester.runAsync(() async {
        await tester.pumpWidget(calendarScreen);
        await tester.pump();

        expect(
          (tester.widget(nowFinder) as MonthCalendarCell).gradient,
          isA<LinearGradient>(),
        );
      });
    },
  );

  testWidgets(
    'Change selected day when tapping another day',
    (tester) async {
      final tappedFinder = find
          .widgetWithText(
            MonthCalendarCell,
            '1',
          )
          .first;

      await tester.runAsync(() async {
        await tester.pumpWidget(calendarScreen);
        await tester.pump();

        await Future.delayed(const Duration(seconds: 3));
        await tester.tap(tappedFinder);
        await tester.pumpAndSettle();

        expect(
          (tester.widget(tappedFinder) as MonthCalendarCell).gradient,
          isA<LinearGradient>(),
        );
      });
    },
  );
}
