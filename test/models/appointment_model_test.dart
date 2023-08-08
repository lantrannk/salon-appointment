import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';

void main() {
  late Appointment appointment;
  late Map<String, dynamic> appointmentJson;

  setUp(() {
    appointment = Appointment(
      id: '1',
      userId: '1',
      date: DateTime(2023, 8, 15),
      startTime: DateTime(2023, 8, 15, 10, 0),
      endTime: DateTime(2023, 8, 15, 10, 30),
      services: 'Shoulder & Neck',
      description: 'Anything',
      isCompleted: false,
    );

    appointmentJson = {
      'date': '2023-08-15T00:00:00.000',
      'startTime': '2023-08-15T10:00:00.000',
      'endTime': '2023-08-15T10:30:00.000',
      'userId': '1',
      'services': 'Shoulder & Neck',
      'description': 'Anything',
      'isCompleted': false,
      'id': '1'
    };
  });

  test('test appointment model - fromJson', () {
    final appointmentFromJson = Appointment.fromJson(appointmentJson);

    expect(appointmentFromJson, appointment);
  });

  test('test appointment model - toJson', () {
    final appointmentToJson = appointment.toJson();

    expect(appointmentToJson, appointmentJson);
  });

  test('test appointment model - date copyWith', () {
    final date = DateTime(2023, 8, 10);
    final dateCopyWith = appointment.copyWith(date: date);

    expect(dateCopyWith.date, date);
  });

  test('test appointment model - start time copyWith', () {
    final startTime = DateTime(2023, 8, 10, 16, 30);
    final startTimeCopyWith = appointment.copyWith(startTime: startTime);

    expect(startTimeCopyWith.startTime, startTime);
  });

  test('test appointment model - end time copyWith', () {
    final endTime = DateTime(2023, 8, 10, 17, 0);
    final appointmentCopyWith = appointment.copyWith(endTime: endTime);

    expect(appointmentCopyWith.endTime, endTime);
  });

  test('test appointment model - services copyWith', () {
    const services = 'Back';
    final appointmentCopyWith = appointment.copyWith(services: services);

    expect(appointmentCopyWith.services, services);
  });

  test('test appointment model - description copyWith', () {
    const description = 'test copy with';
    final appointmentCopyWith = appointment.copyWith(description: description);

    expect(appointmentCopyWith.description, description);
  });

  test('test appointment model - is completed copyWith', () {
    const isCompleted = true;
    final appointmentCopyWith = appointment.copyWith(isCompleted: isCompleted);

    expect(appointmentCopyWith.isCompleted, isCompleted);
  });
}
