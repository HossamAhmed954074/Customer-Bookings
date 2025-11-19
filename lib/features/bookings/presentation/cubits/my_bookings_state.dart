import 'package:customer_booking/features/bookings/domain/entities/booking_entity.dart';
import 'package:equatable/equatable.dart';

enum MyBookingsStatus { initial, loading, success, error, cancelling }

class MyBookingsState extends Equatable {
  final MyBookingsStatus status;
  final List<BookingEntity> bookings;
  final String? errorMessage;
  final String? cancellingBookingId;

  const MyBookingsState({
    this.status = MyBookingsStatus.initial,
    this.bookings = const [],
    this.errorMessage,
    this.cancellingBookingId,
  });

  List<BookingEntity> get upcomingBookings =>
      bookings.where((b) => b.isUpcoming).toList();

  List<BookingEntity> get pastBookings =>
      bookings.where((b) => b.isPast).toList();

  List<BookingEntity> get cancelledBookings =>
      bookings.where((b) => b.isCancelled).toList();

  MyBookingsState copyWith({
    MyBookingsStatus? status,
    List<BookingEntity>? bookings,
    String? errorMessage,
    String? cancellingBookingId,
  }) {
    return MyBookingsState(
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      errorMessage: errorMessage,
      cancellingBookingId: cancellingBookingId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    bookings,
    errorMessage,
    cancellingBookingId,
  ];
}
