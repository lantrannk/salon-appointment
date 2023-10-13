import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/appointments/repository/appointment_repository.dart';
import 'package:salon_appointment/features/auth/repository/user_repository.dart';

class MockAppointmentRepo extends Mock implements AppointmentRepository {}

class MockUserRepository extends Mock implements UserRepository {}
