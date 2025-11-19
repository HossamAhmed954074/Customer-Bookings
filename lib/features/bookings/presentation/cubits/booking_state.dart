import 'package:customer_booking/features/bookings/domain/entities/booking_entity.dart';
import 'package:equatable/equatable.dart';

enum BookingStatus { initial, loading, success, error }

class BookingState extends Equatable {
  final BookingStatus status;
  final BookingEntity? booking;
  final String? errorMessage;

  const BookingState({
    this.status = BookingStatus.initial,
    this.booking,
    this.errorMessage,
  });

  BookingState copyWith({
    BookingStatus? status,
    BookingEntity? booking,
    String? errorMessage,
  }) {
    return BookingState(
      status: status ?? this.status,
      booking: booking ?? this.booking,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, booking, errorMessage];
}
