import 'package:customer_booking/features/home/domain/entities/session_entity.dart';

class SessionModel extends Session {
  const SessionModel({
    required super.id,
    required super.businessId,
    required super.name,
    required super.instructorName,
    super.description,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.duration,
    required super.capacity,
    required super.bookedCount,
    required super.credits,
    required super.level,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['_id'] ?? json['id'] ?? '',
      businessId: json['businessId'] ?? '',
      name: json['name'] ?? '',
      instructorName: json['instructorName'] ?? json['instructor'] ?? '',
      description: json['description'],
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      duration: json['duration'] ?? 0,
      capacity: json['capacity'] ?? 0,
      bookedCount: json['bookedSpots'] ?? json['bookedCount'] ?? 0,
      credits: json['credits'] ?? 0,
      level: json['level'] ?? 'all',
    );
  }

  Session toEntity() {
    return Session(
      id: id,
      businessId: businessId,
      name: name,
      instructorName: instructorName,
      description: description,
      date: date,
      startTime: startTime,
      endTime: endTime,
      duration: duration,
      capacity: capacity,
      bookedCount: bookedCount,
      credits: credits,
      level: level,
    );
  }
}
