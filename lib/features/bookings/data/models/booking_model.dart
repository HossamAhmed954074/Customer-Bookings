import 'package:customer_booking/features/bookings/domain/entities/booking_entity.dart';

class BookingModel {
  final String id;
  final String sessionId;
  final String userId;
  final String businessId;
  final String businessName;
  final String sessionName;
  final String sessionDate;
  final String sessionStartTime;
  final String sessionEndTime;
  final int credits;
  final String status;
  final String? notes;
  final String createdAt;
  final String? cancelledAt;

  BookingModel({
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

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    // Debug date formats
    print('=== BOOKING DATE DEBUG ===');
    print('sessionDate from API: ${json['sessionDate']}');
    print('createdAt from API: ${json['createdAt']}');
    print('cancelledAt from API: ${json['cancelledAt']}');
    
    return BookingModel(
      id: json['_id'] ?? json['id'] ?? '',
      sessionId: json['sessionId'] ?? '',
      userId: json['userId'] ?? '',
      businessId: json['businessId'] ?? '',
      businessName: json['businessName'] ?? '',
      sessionName: json['sessionName'] ?? '',
      sessionDate: json['sessionDate'] ?? '',
      sessionStartTime: json['sessionStartTime'] ?? json['startTime'] ?? '',
      sessionEndTime: json['sessionEndTime'] ?? json['endTime'] ?? '',
      credits: json['credits'] ?? 0,
      status: json['status'] ?? 'confirmed',
      notes: json['notes'],
      createdAt: json['createdAt'] ?? DateTime.now().toIso8601String(),
      cancelledAt: json['cancelledAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'userId': userId,
      'businessId': businessId,
      'businessName': businessName,
      'sessionName': sessionName,
      'sessionDate': sessionDate,
      'sessionStartTime': sessionStartTime,
      'sessionEndTime': sessionEndTime,
      'credits': credits,
      'status': status,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt,
      if (cancelledAt != null) 'cancelledAt': cancelledAt,
    };
  }

  BookingEntity toEntity() {
    return BookingEntity(
      id: id,
      sessionId: sessionId,
      userId: userId,
      businessId: businessId,
      businessName: businessName,
      sessionName: sessionName,
      sessionDate: _parseDate(sessionDate),
      sessionStartTime: sessionStartTime,
      sessionEndTime: sessionEndTime,
      credits: credits,
      status: status,
      notes: notes,
      createdAt: _parseDate(createdAt),
      cancelledAt: cancelledAt != null ? _parseDate(cancelledAt!) : null,
    );
  }

  DateTime _parseDate(String dateString) {
    try {
      // Try ISO 8601 format first
      return DateTime.parse(dateString);
    } catch (e) {
      try {
        // Try parsing common date formats
        // Format: "YYYY-MM-DD" or "DD/MM/YYYY" or "MM/DD/YYYY"
        if (dateString.contains('/')) {
          final parts = dateString.split('/');
          if (parts.length == 3) {
            // Try MM/DD/YYYY
            if (parts[0].length <= 2) {
              final month = int.parse(parts[0]);
              final day = int.parse(parts[1]);
              final year = int.parse(parts[2]);
              return DateTime(year, month, day);
            }
          }
        } else if (dateString.contains('-') && !dateString.contains('T')) {
          // Format: YYYY-MM-DD (without time)
          final parts = dateString.split('-');
          if (parts.length == 3) {
            final year = int.parse(parts[0]);
            final month = int.parse(parts[1]);
            final day = int.parse(parts[2]);
            return DateTime(year, month, day);
          }
        }
      } catch (parseError) {
        // If all parsing fails, return current date
        print('Failed to parse date: $dateString, error: $parseError');
      }
      // Fallback to current date if parsing fails
      return DateTime.now();
    }
  }
}
