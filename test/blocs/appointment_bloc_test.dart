import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/features/appointments/bloc/appointment_bloc.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  final appointment = Appointment.fromJson({
    'date': '2023-08-15T10:55:00.000',
    'startTime': '2023-08-15T19:00:00.000',
    'endTime': '2023-08-15T19:30:00.000',
    'userId': '1',
    'services': 'Non-Invasive Body Contouring',
    'description': 'Nothing to write.',
    'isCompleted': false,
    'id': '81'
  });

  final appointments = [
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
      'date': '2023-06-30T00:00:00.000',
      'startTime': '2023-06-30T16:00:00.000',
      'endTime': '2023-06-30T16:30:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'abcdefghiklmnopqrstuvwxyz',
      'isCompleted': false,
      'id': '47'
    },
    {
      'date': '2023-06-30T00:00:00.000',
      'startTime': '2023-06-30T09:00:00.000',
      'endTime': '2023-06-30T09:30:00.000',
      'userId': '2',
      'services': 'Neck & Shoulders',
      'description': 'b jcxbvjbks',
      'isCompleted': false,
      'id': '50'
    },
    {
      'date': '2023-07-02T00:00:00.000',
      'startTime': '2023-07-02T11:00:00.000',
      'endTime': '2023-07-02T11:30:00.000',
      'userId': '1',
      'services': 'Neck & Shoulders',
      'description': 'afbsajlfbsigdslbh',
      'isCompleted': false,
      'id': '52'
    },
    {
      'date': '2023-06-29T00:00:00.000',
      'startTime': '2023-06-29T08:00:00.000',
      'endTime': '2023-06-29T08:30:00.000',
      'userId': '2',
      'services': 'Back',
      'description': 'b jcxbvjbks',
      'isCompleted': false,
      'id': '53'
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
      'date': '2023-07-01T00:00:00.000',
      'startTime': '2023-07-01T17:00:00.000',
      'endTime': '2023-07-01T17:30:00.000',
      'userId': '2',
      'services': 'Non-Invasive Body Contouring',
      'description': 'asfasgdsehbxvsgs',
      'isCompleted': false,
      'id': '58'
    },
    {
      'date': '2023-07-03T00:00:00.000',
      'startTime': '2023-07-03T10:00:00.000',
      'endTime': '2023-07-03T10:30:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'abfsahjsiluhgioahfiks',
      'isCompleted': false,
      'id': '59'
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
      'date': '2023-07-13T19:12:00.000',
      'startTime': '2023-07-13T09:00:00.000',
      'endTime': '2023-07-13T09:30:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description':
          '0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567980123456798012345678901236546464',
      'isCompleted': false,
      'id': '77'
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
    }
  ].map((e) => Appointment.fromJson(e)).toList();

  final appointmentsOfUser = [
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
      'date': '2023-06-30T00:00:00.000',
      'startTime': '2023-06-30T09:00:00.000',
      'endTime': '2023-06-30T09:30:00.000',
      'userId': '2',
      'services': 'Neck & Shoulders',
      'description': 'b jcxbvjbks',
      'isCompleted': false,
      'id': '50'
    },
    {
      'date': '2023-06-29T00:00:00.000',
      'startTime': '2023-06-29T08:00:00.000',
      'endTime': '2023-06-29T08:30:00.000',
      'userId': '2',
      'services': 'Back',
      'description': 'b jcxbvjbks',
      'isCompleted': false,
      'id': '53'
    },
    {
      'date': '2023-07-01T00:00:00.000',
      'startTime': '2023-07-01T17:00:00.000',
      'endTime': '2023-07-01T17:30:00.000',
      'userId': '2',
      'services': 'Non-Invasive Body Contouring',
      'description': 'asfasgdsehbxvsgs',
      'isCompleted': false,
      'id': '58'
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
  ];

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('test appointment bloc -', () {
    blocTest(
      'load appointments successful by admin',
      build: () => AppointmentBloc(),
      act: (bloc) => bloc.add(
        AppointmentLoad(),
      ),
      wait: const Duration(seconds: 3),
      setUp: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'user',
          '{"phoneNumber":"0794542105","name":"Lan Tran","avatar":"https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg","password":"123456","isAdmin":true,"id":"1"}',
        );
      },
      expect: () => [
        isA<AppointmentLoading>(),
        isA<AppointmentLoadSuccess>()
          ..having(
            (p0) => p0.appointments,
            'appointments list',
            appointments,
          ),
      ],
    );

    blocTest(
      'load appointments successful by customer',
      build: () => AppointmentBloc(),
      act: (bloc) => bloc.add(
        AppointmentLoad(),
      ),
      wait: const Duration(seconds: 3),
      setUp: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'user',
          '{"phoneNumber":"0905999222","name":"Carol Williams","avatar":"https://assets.vogue.in/photos/611cf20c8733032148fe1b06/2:3/w_2560%2Cc_limit/Slide%25201.jpg","password":"123456","isAdmin":false,"id":"2"}',
        );
      },
      expect: () => [
        isA<AppointmentLoading>(),
        isA<AppointmentLoadSuccess>()
          ..having(
            (p0) => prints(p0.appointments),
            'appointments list',
            appointmentsOfUser,
          ),
      ],
    );

    blocTest(
      'add appointment successful',
      build: () => AppointmentBloc(),
      act: (bloc) => bloc.add(
        AppointmentAdd(appointment: appointment),
      ),
      wait: const Duration(seconds: 3),
      setUp: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'user',
          '{"phoneNumber":"0794542105","name":"Lan Tran","avatar":"https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg","password":"123456","isAdmin":true,"id":"1"}',
        );
      },
      expect: () => [
        isA<AppointmentAdding>(),
        isA<AppointmentAdded>(),
      ],
    );

    blocTest(
      'update appointment successful',
      build: () => AppointmentBloc(),
      act: (bloc) => bloc.add(
        AppointmentEdit(
          appointment: appointment.copyWith(services: 'Back'),
        ),
      ),
      wait: const Duration(seconds: 3),
      setUp: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'user',
          '{"phoneNumber":"0794542105","name":"Lan Tran","avatar":"https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg","password":"123456","isAdmin":true,"id":"1"}',
        );
      },
      expect: () => [
        isA<AppointmentAdding>(),
        isA<AppointmentEdited>(),
      ],
    );

    blocTest(
      'remove appointment successful',
      build: () => AppointmentBloc(),
      act: (bloc) => bloc.add(
        AppointmentRemovePressed(
          appointmentId: appointment.id!,
        ),
      ),
      wait: const Duration(seconds: 3),
      setUp: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'user',
          '{"phoneNumber":"0794542105","name":"Lan Tran","avatar":"https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg","password":"123456","isAdmin":true,"id":"1"}',
        );
      },
      expect: () => [
        isA<AppointmentRemoving>(),
        isA<AppointmentRemoved>(),
      ],
    );
  });
}
