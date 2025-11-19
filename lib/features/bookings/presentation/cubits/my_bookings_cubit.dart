import 'package:customer_booking/features/bookings/domain/usecases/cancel_booking_usecase.dart';
import 'package:customer_booking/features/bookings/domain/usecases/get_my_bookings_usecase.dart';
import 'package:customer_booking/features/bookings/presentation/cubits/my_bookings_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyBookingsCubit extends Cubit<MyBookingsState> {
  final GetMyBookingsUseCase getMyBookingsUseCase;
  final CancelBookingUseCase cancelBookingUseCase;

  MyBookingsCubit({
    required this.getMyBookingsUseCase,
    required this.cancelBookingUseCase,
  }) : super(const MyBookingsState());

  Future<void> loadBookings({String? status}) async {
    try {
      emit(state.copyWith(status: MyBookingsStatus.loading));

      debugPrint('Loading bookings with status filter: ${status ?? "all"}');
      final result = await getMyBookingsUseCase(status: status);

      result.fold(
        (error) {
          debugPrint('Failed to load bookings: $error');
          emit(
            state.copyWith(
              status: MyBookingsStatus.error,
              errorMessage: error,
            ),
          );
        },
        (bookings) {
          debugPrint('Loaded ${bookings.length} bookings');
          emit(
            state.copyWith(
              status: MyBookingsStatus.success,
              bookings: bookings,
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('Unexpected error in loadBookings: $e');
      emit(
        state.copyWith(
          status: MyBookingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      emit(
        state.copyWith(
          status: MyBookingsStatus.cancelling,
          cancellingBookingId: bookingId,
        ),
      );

      debugPrint('Cancelling booking: $bookingId');
      final result = await cancelBookingUseCase(bookingId);

      result.fold(
        (error) {
          debugPrint('Failed to cancel booking: $error');
          emit(
            state.copyWith(
              status: MyBookingsStatus.error,
              errorMessage: error,
              cancellingBookingId: null,
            ),
          );
        },
        (cancelledBooking) {
          debugPrint('Booking cancelled successfully: ${cancelledBooking.id}');
          
          // Update the booking in the list
          final updatedBookings = state.bookings.map((booking) {
            if (booking.id == cancelledBooking.id) {
              return cancelledBooking;
            }
            return booking;
          }).toList();

          emit(
            state.copyWith(
              status: MyBookingsStatus.success,
              bookings: updatedBookings,
              cancellingBookingId: null,
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('Unexpected error in cancelBooking: $e');
      emit(
        state.copyWith(
          status: MyBookingsStatus.error,
          errorMessage: e.toString(),
          cancellingBookingId: null,
        ),
      );
    }
  }

  Future<void> refreshBookings() async {
    await loadBookings();
  }
}
