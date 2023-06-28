// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `avisit`
  String get logo {
    return Intl.message(
      'avisit',
      name: 'logo',
      desc: '',
      args: [],
    );
  }

  /// `av`
  String get logoText {
    return Intl.message(
      'av',
      name: 'logoText',
      desc: '',
      args: [],
    );
  }

  /// `From:`
  String get fromText {
    return Intl.message(
      'From:',
      name: 'fromText',
      desc: '',
      args: [],
    );
  }

  /// `To:`
  String get toText {
    return Intl.message(
      'To:',
      name: 'toText',
      desc: '',
      args: [],
    );
  }

  /// `Beauty Salon`
  String get beautySalonText {
    return Intl.message(
      'Beauty Salon',
      name: 'beautySalonText',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phoneNumber {
    return Intl.message(
      'Phone number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get loginButton {
    return Intl.message(
      'Log in',
      name: 'loginButton',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get calendarAppBarTitle {
    return Intl.message(
      'Calendar',
      name: 'calendarAppBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Appointments`
  String get appointmentAppBarTitle {
    return Intl.message(
      'Appointments',
      name: 'appointmentAppBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `New Appointment`
  String get newAppointmentAppBarTitle {
    return Intl.message(
      'New Appointment',
      name: 'newAppointmentAppBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileAppBarTitle {
    return Intl.message(
      'Profile',
      name: 'profileAppBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit Appointment`
  String get editAppointmentAppBarTitle {
    return Intl.message(
      'Edit Appointment',
      name: 'editAppointmentAppBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `There are no appointments.`
  String get emptyAppointments {
    return Intl.message(
      'There are no appointments.',
      name: 'emptyAppointments',
      desc: '',
      args: [],
    );
  }

  /// `Nothing to write.`
  String get defaultDescription {
    return Intl.message(
      'Nothing to write.',
      name: 'defaultDescription',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Create New Appointment`
  String get createAppointmentButton {
    return Intl.message(
      'Create New Appointment',
      name: 'createAppointmentButton',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get editAppointmentButton {
    return Intl.message(
      'Submit',
      name: 'editAppointmentButton',
      desc: '',
      args: [],
    );
  }

  /// `Appointment added`
  String get addSuccess {
    return Intl.message(
      'Appointment added',
      name: 'addSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to create appointment`
  String get addFail {
    return Intl.message(
      'Failed to create appointment',
      name: 'addFail',
      desc: '',
      args: [],
    );
  }

  /// `Appointment updated.`
  String get updateSuccess {
    return Intl.message(
      'Appointment updated.',
      name: 'updateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Appointment deleted.`
  String get deleteSuccess {
    return Intl.message(
      'Appointment deleted.',
      name: 'deleteSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Appointments`
  String get appointmentsLabel {
    return Intl.message(
      'Appointments',
      name: 'appointmentsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get calendarLabel {
    return Intl.message(
      'Calendar',
      name: 'calendarLabel',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileLabel {
    return Intl.message(
      'Profile',
      name: 'profileLabel',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notificationsLabel {
    return Intl.message(
      'Notifications',
      name: 'notificationsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Remove Appointment`
  String get removeConfirmTitle {
    return Intl.message(
      'Remove Appointment',
      name: 'removeConfirmTitle',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete this appointment?`
  String get removeConfirmMessage {
    return Intl.message(
      'Do you want to delete this appointment?',
      name: 'removeConfirmMessage',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logoutConfirmTitle {
    return Intl.message(
      'Logout',
      name: 'logoutConfirmTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to logout?`
  String get logoutConfirmMessage {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'logoutConfirmMessage',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yesConfirm {
    return Intl.message(
      'Yes',
      name: 'yesConfirm',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get noConfirm {
    return Intl.message(
      'No',
      name: 'noConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Phone number or Password is invalid.`
  String get invalidAccountError {
    return Intl.message(
      'Phone number or Password is invalid.',
      name: 'invalidAccountError',
      desc: '',
      args: [],
    );
  }

  /// `Phone number or Password is incorrect.`
  String get incorrectAccountError {
    return Intl.message(
      'Phone number or Password is incorrect.',
      name: 'incorrectAccountError',
      desc: '',
      args: [],
    );
  }

  /// `This is the break time of Salon. You must pick another time not between 12 pm and 3:20 pm.`
  String get breakTimeConflictError {
    return Intl.message(
      'This is the break time of Salon. You must pick another time not between 12 pm and 3:20 pm.',
      name: 'breakTimeConflictError',
      desc: '',
      args: [],
    );
  }

  /// `Salon is already closed. Please schedule an appointment after 8 am the after day.`
  String get closedTimeError {
    return Intl.message(
      'Salon is already closed. Please schedule an appointment after 8 am the after day.',
      name: 'closedTimeError',
      desc: '',
      args: [],
    );
  }

  /// `You must choose a service.`
  String get emptyServicesError {
    return Intl.message(
      'You must choose a service.',
      name: 'emptyServicesError',
      desc: '',
      args: [],
    );
  }

  /// `You cannot edit appointments in less than 24 hours.`
  String get unableEditError {
    return Intl.message(
      'You cannot edit appointments in less than 24 hours.',
      name: 'unableEditError',
      desc: '',
      args: [],
    );
  }

  /// `The end time must be after the start time of at least 30 minutes.`
  String get invalidEndTimeError {
    return Intl.message(
      'The end time must be after the start time of at least 30 minutes.',
      name: 'invalidEndTimeError',
      desc: '',
      args: [],
    );
  }

  /// `You cannot choose a time before now.`
  String get invalidStartTimeError {
    return Intl.message(
      'You cannot choose a time before now.',
      name: 'invalidStartTimeError',
      desc: '',
      args: [],
    );
  }

  /// `This time is full of appointments. Please pick another time.`
  String get fullAppointmentsError {
    return Intl.message(
      'This time is full of appointments. Please pick another time.',
      name: 'fullAppointmentsError',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
