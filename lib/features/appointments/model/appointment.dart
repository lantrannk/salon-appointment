import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  const Appointment({
    required this.userId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.services,
    required this.description,
    this.id,
    this.isCompleted = false,
  });

  factory Appointment.fromJson(Map<dynamic, dynamic> appointment) {
    return Appointment(
      id: appointment['id'] as String,
      userId: appointment['userId'] as String,
      date: DateTime.parse(appointment['date'] as String),
      startTime: DateTime.parse(appointment['startTime'] as String),
      endTime: DateTime.parse(appointment['endTime'] as String),
      services: appointment['services'] as String,
      description: appointment['description'] as String,
      isCompleted: appointment['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'date': date.toIso8601String(),
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'services': services,
        'description': description,
        'isCompleted': isCompleted,
      };

  Appointment copyWith({
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    String? services,
    String? description,
    bool? isCompleted,
  }) =>
      Appointment(
        id: id,
        userId: userId,
        date: date ?? this.date,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        services: services ?? this.services,
        description: description ?? this.description,
        isCompleted: isCompleted ?? this.isCompleted,
      );

  final String? id;
  final String services;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String userId;
  final String description;
  final bool isCompleted;

  @override
  List<Object?> get props => [
        id,
        date,
        startTime,
        endTime,
        userId,
        services,
        description,
        isCompleted,
      ];
}
