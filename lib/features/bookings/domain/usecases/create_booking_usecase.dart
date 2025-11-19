import 'package:customer_booking/features/bookings/domain/entities/booking_entity.dart';
import 'package:customer_booking/features/bookings/domain/entities/create_booking_request.dart';
import 'package:customer_booking/features/bookings/domain/repo/booking_repository.dart';
import 'package:dartz/dartz.dart';

class CreateBookingUseCase {
  final BookingRepository repository;

  CreateBookingUseCase({required this.repository});

  Future<Either<String, BookingEntity>> call(CreateBookingRequest request) {
    return repository.createBooking(request);
  }
}
