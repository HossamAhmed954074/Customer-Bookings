import 'package:equatable/equatable.dart';

class CreateBookingRequest extends Equatable {
  final String sessionId;
  final String? notes;
  final String? idempotencyKey;
  final String status;

  const CreateBookingRequest({
    required this.sessionId,
    this.notes,
    this.idempotencyKey,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [sessionId, notes, idempotencyKey, status];
}
