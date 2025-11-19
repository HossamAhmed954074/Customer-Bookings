import 'package:customer_booking/features/bookings/domain/entities/booking_entity.dart';
import 'package:customer_booking/features/bookings/domain/repo/booking_repository.dart';
import 'package:dartz/dartz.dart';

class GetMyBookingsUseCase {
  final BookingRepository repository;

  GetMyBookingsUseCase({required this.repository});

  Future<Either<String, List<BookingEntity>>> call({String? status}) {
    return repository.getMyBookings(status: status);
  }
}
