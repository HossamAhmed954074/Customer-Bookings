import 'package:customer_booking/features/bookings/domain/entities/create_booking_request.dart';
import 'package:customer_booking/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:customer_booking/features/bookings/presentation/cubits/booking_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingCubit extends Cubit<BookingState> {
  final CreateBookingUseCase createBookingUseCase;

  BookingCubit({
    required this.createBookingUseCase,
  }) : super(const BookingState());

  Future<void> createBooking({
    required String sessionId,
    String? notes,
  }) async {
    try {
      emit(state.copyWith(status: BookingStatus.loading));

      // Generate idempotency key
      final idempotencyKey = '${DateTime.now().millisecondsSinceEpoch}_$sessionId';

      final request = CreateBookingRequest(
        sessionId: sessionId,
        notes: notes,
        idempotencyKey: idempotencyKey,
      );

      debugPrint('Creating booking for session: $sessionId');
      final result = await createBookingUseCase(request);

      result.fold(
        (error) {
          debugPrint('Booking creation failed: $error');
          emit(
            state.copyWith(
              status: BookingStatus.error,
              errorMessage: error,
            ),
          );
        },
        (booking) {
          debugPrint('Booking created successfully: ${booking.id}');
          emit(
            state.copyWith(
              status: BookingStatus.success,
              booking: booking,
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('Unexpected error in createBooking: $e');
      emit(
        state.copyWith(
          status: BookingStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void reset() {
    emit(const BookingState());
  }
}
