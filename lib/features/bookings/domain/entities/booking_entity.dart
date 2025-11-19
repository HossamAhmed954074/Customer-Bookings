import 'package:equatable/equatable.dart';

class BookingEntity extends Equatable {
  final String id;
  final String sessionId;
  final String userId;
  final String businessId;
  final String businessName;
  final String sessionName;
  final DateTime sessionDate;
  final String sessionStartTime;
  final String sessionEndTime;
  final int credits;
  final String status; // 'confirmed', 'cancelled', 'completed'
  final String? notes;
  final DateTime createdAt;
  final DateTime? cancelledAt;

  const BookingEntity({
    required this.id,
    required this.sessionId,
    required this.userId,
    required this.businessId,
    required this.businessName,
    required this.sessionName,
    required this.sessionDate,
    required this.sessionStartTime,
    required this.sessionEndTime,
    required this.credits,
    required this.status,
    this.notes,
    required this.createdAt,
    this.cancelledAt,
  });

  bool get isUpcoming =>
      status == 'confirmed' && sessionDate.isAfter(DateTime.now());
  bool get isPast =>
      status == 'completed' || sessionDate.isBefore(DateTime.now());
  bool get isCancelled => status == 'cancelled';

  @override
  List<Object?> get props => [
    id,
    sessionId,
    userId,
    businessId,
    businessName,
    sessionName,
    sessionDate,
    sessionStartTime,
    sessionEndTime,
    credits,
    status,
    notes,
    createdAt,
    cancelledAt,
  ];
}
