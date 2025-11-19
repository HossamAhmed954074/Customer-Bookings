import 'package:equatable/equatable.dart';

class CreateBookingRequest extends Equatable {
  final String sessionId;
  final String? notes;
  final String? idempotencyKey;

  const CreateBookingRequest({
    required this.sessionId,
    this.notes,
    this.idempotencyKey,
  });

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }

  @override
  List<Object?> get props => [sessionId, notes, idempotencyKey];
}
