import 'package:customer_booking/features/bookings/domain/entities/booking_entity.dart';
import 'package:customer_booking/features/bookings/domain/entities/create_booking_request.dart';
import 'package:dartz/dartz.dart';

abstract class BookingRepository {
  /// Create a new booking
  Future<Either<String, BookingEntity>> createBooking(
    CreateBookingRequest request,
  );

  /// Get all bookings for the current user
  Future<Either<String, List<BookingEntity>>> getMyBookings({String? status});

  /// Get a specific booking by ID
  Future<Either<String, BookingEntity>> getBookingById(String bookingId);

  /// Cancel a booking
  Future<Either<String, BookingEntity>> cancelBooking(String bookingId);
}
