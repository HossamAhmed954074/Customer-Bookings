import 'package:customer_booking/features/bookings/domain/entities/booking_entity.dart';
import 'package:customer_booking/features/bookings/domain/repo/booking_repository.dart';
import 'package:dartz/dartz.dart';

class CancelBookingUseCase {
  final BookingRepository repository;

  CancelBookingUseCase({required this.repository});

  Future<Either<String, BookingEntity>> call(String bookingId) {
    return repository.cancelBooking(bookingId);
  }
}
