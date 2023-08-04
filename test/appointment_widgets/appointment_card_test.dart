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
import 'package:salon_appointment/features/appointments/screens/appointments_screen.dart';
import 'package:salon_appointment/features/appointments/screens/appointments_widgets/appointments_widgets.dart';

import 'package:salon_appointment/features/auth/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAppointmentBloc extends Mock implements AppointmentBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late AppointmentBloc appointmentBloc;
  late Widget appointmentScreen;
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
    },
  ].map((e) => Appointment.fromJson(e)).toList();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    appointmentBloc = MockAppointmentBloc();
    appointmentScreen = MediaQuery(
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
          child: AppointmentScreen(
            focusedDay: DateTime(2023, 08, 15),
          ),
        ),
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'user',
      '{"phoneNumber":"0794542105","name":"Lan Tran","avatar":"https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg","password":"123456","isAdmin":true,"id":"1"}',
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
  });

  testWidgets(
    'Appointment Card has one appointment time widget',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(appointmentScreen);
        await tester.pump();

        await Future.delayed(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        expect(
          find.widgetWithText(
            AppointmentCard,
            '18:00 - 18:30',
          ),
          findsOneWidget,
        );

        expect(
          find.widgetWithText(
            AppointmentCard,
            '19:00 - 19:30',
          ),
          findsOneWidget,
        );

        expect(
          find.widgetWithText(
            AppointmentCard,
            'Beauty Salon',
          ),
          findsNWidgets(2),
        );
      });
    },
  );

  testWidgets(
    'Appointment Card has one customer\'s name widget',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(appointmentScreen);
        await tester.pump();

        await Future.delayed(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        expect(
          find.widgetWithText(AppointmentCard, 'Carol Williams'),
          findsOneWidget,
        );

        expect(
          find.widgetWithText(AppointmentCard, 'Lan Tran'),
          findsOneWidget,
        );
      });
    },
  );

  testWidgets(
    'Appointment Card has one appointment service widget',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(appointmentScreen);
        await tester.pump();

        await Future.delayed(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        expect(
          find.widgetWithText(
            AppointmentCard,
            'Non-Invasive Body Contouring',
          ),
          findsNWidgets(2),
        );
      });
    },
  );

  testWidgets(
    'Appointment Card has one appointment description widget',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(appointmentScreen);
        await tester.pump();

        await Future.delayed(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        expect(
          find.widgetWithText(
            AppointmentCard,
            'Nothing to write.',
          ),
          findsNWidgets(2),
        );
      });
    },
  );
}
