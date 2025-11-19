import 'package:customer_booking/features/bookings/data/datasource/booking_remote_data_source.dart';
import 'package:customer_booking/features/bookings/domain/entities/booking_entity.dart';
import 'package:customer_booking/features/bookings/domain/entities/create_booking_request.dart';
import 'package:customer_booking/features/bookings/domain/repo/booking_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, BookingEntity>> createBooking(
    CreateBookingRequest request,
  ) async {
    try {
      final bookingModel = await remoteDataSource.createBooking(request);
      return Right(bookingModel.toEntity());
    } catch (e) {
      debugPrint('Error in BookingRepository.createBooking: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<BookingEntity>>> getMyBookings({
    String? status,
  }) async {
    try {
      final bookingModels = await remoteDataSource.getMyBookings(
        status: status,
      );
      final bookings = bookingModels.map((m) => m.toEntity()).toList();
      return Right(bookings);
    } catch (e) {
      debugPrint('Error in BookingRepository.getMyBookings: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, BookingEntity>> getBookingById(String bookingId) async {
    try {
      final bookingModel = await remoteDataSource.getBookingById(bookingId);
      return Right(bookingModel.toEntity());
    } catch (e) {
      debugPrint('Error in BookingRepository.getBookingById: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, BookingEntity>> cancelBooking(String bookingId) async {
    try {
      final bookingModel = await remoteDataSource.cancelBooking(bookingId);
      return Right(bookingModel.toEntity());
    } catch (e) {
      debugPrint('Error in BookingRepository.cancelBooking: $e');
      return Left(e.toString());
    }
  }
}
