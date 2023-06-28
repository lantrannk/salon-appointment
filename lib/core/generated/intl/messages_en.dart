// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addFail": MessageLookupByLibrary.simpleMessage(
            "Failed to create appointment"),
        "addSuccess": MessageLookupByLibrary.simpleMessage("Appointment added"),
        "appointmentAppBarTitle":
            MessageLookupByLibrary.simpleMessage("Appointments"),
        "appointmentsLabel":
            MessageLookupByLibrary.simpleMessage("Appointments"),
        "breakTimeConflictError": MessageLookupByLibrary.simpleMessage(
            "This is the break time of Salon. You must pick another time not between 12 pm and 3:20 pm."),
        "calendarAppBarTitle": MessageLookupByLibrary.simpleMessage("Calendar"),
        "calendarLabel": MessageLookupByLibrary.simpleMessage("Calendar"),
        "closedTimeError": MessageLookupByLibrary.simpleMessage(
            "Salon is already closed. Please schedule an appointment after 8 am the after day."),
        "createAppointmentButton":
            MessageLookupByLibrary.simpleMessage("Create New Appointment"),
        "defaultDescription":
            MessageLookupByLibrary.simpleMessage("Nothing to write."),
        "deleteSuccess":
            MessageLookupByLibrary.simpleMessage("Appointment deleted."),
        "description": MessageLookupByLibrary.simpleMessage("Description"),
        "editAppointmentAppBarTitle":
            MessageLookupByLibrary.simpleMessage("Edit Appointment"),
        "editAppointmentButton": MessageLookupByLibrary.simpleMessage("Submit"),
        "emptyAppointments":
            MessageLookupByLibrary.simpleMessage("There are no appointments."),
        "emptyServicesError":
            MessageLookupByLibrary.simpleMessage("You must choose a service."),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot password?"),
        "fromText": MessageLookupByLibrary.simpleMessage("From:"),
        "fullAppointmentsError": MessageLookupByLibrary.simpleMessage(
            "This time is full of appointments. Please pick another time."),
        "incorrectAccountError": MessageLookupByLibrary.simpleMessage(
            "Phone number or Password is incorrect."),
        "invalidAccountError": MessageLookupByLibrary.simpleMessage(
            "Phone number or Password is invalid."),
        "invalidEndTimeError": MessageLookupByLibrary.simpleMessage(
            "The end time must be after the start time of at least 30 minutes."),
        "invalidStartTimeError": MessageLookupByLibrary.simpleMessage(
            "You cannot choose a time before now."),
        "loginButton": MessageLookupByLibrary.simpleMessage("Log in"),
        "logo": MessageLookupByLibrary.simpleMessage("avisit"),
        "logoText": MessageLookupByLibrary.simpleMessage("av"),
        "logoutConfirmMessage": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to logout?"),
        "logoutConfirmTitle": MessageLookupByLibrary.simpleMessage("Logout"),
        "newAppointmentAppBarTitle":
            MessageLookupByLibrary.simpleMessage("New Appointment"),
        "noConfirm": MessageLookupByLibrary.simpleMessage("No"),
        "notificationsLabel":
            MessageLookupByLibrary.simpleMessage("Notifications"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone number"),
        "profileAppBarTitle": MessageLookupByLibrary.simpleMessage("Profile"),
        "profileLabel": MessageLookupByLibrary.simpleMessage("Profile"),
        "removeConfirmMessage": MessageLookupByLibrary.simpleMessage(
            "Do you want to delete this appointment?"),
        "removeConfirmTitle":
            MessageLookupByLibrary.simpleMessage("Remove Appointment"),
        "toText": MessageLookupByLibrary.simpleMessage("To:"),
        "unableEditError": MessageLookupByLibrary.simpleMessage(
            "You cannot edit appointments in less than 24 hours."),
        "updateSuccess":
            MessageLookupByLibrary.simpleMessage("Appointment updated."),
        "yesConfirm": MessageLookupByLibrary.simpleMessage("Yes")
      };
}
