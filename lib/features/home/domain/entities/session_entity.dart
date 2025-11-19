import 'package:equatable/equatable.dart';

class Session extends Equatable {
  final String id;
  final String businessId;
  final String name;
  final String instructorName;
  final String? description;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int duration;
  final int capacity;
  final int bookedCount;
  final int credits;
  final String level;

  const Session({
    required this.id,
    required this.businessId,
    required this.name,
    required this.instructorName,
    this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.capacity,
    required this.bookedCount,
    required this.credits,
    required this.level,
  });

  bool get hasAvailableSpots => bookedCount < capacity;

  int get availableSpots => capacity - bookedCount;

  @override
  List<Object?> get props => [
    id,
    businessId,
    name,
    instructorName,
    description,
    date,
    startTime,
    endTime,
    duration,
    capacity,
    bookedCount,
    credits,
    level,
  ];
}
