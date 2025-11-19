import 'package:customer_booking/core/services/api/api_consumer.dart';
import 'package:customer_booking/core/presentation/cubits/user_profile_cubit.dart';
import 'package:customer_booking/features/bookings/data/datasource/booking_remote_data_source.dart';
import 'package:customer_booking/features/bookings/data/repo/booking_repository_impl.dart';
import 'package:customer_booking/features/bookings/domain/repo/booking_repository.dart';
import 'package:customer_booking/features/bookings/domain/usecases/cancel_booking_usecase.dart';
import 'package:customer_booking/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:customer_booking/features/bookings/domain/usecases/get_my_bookings_usecase.dart';
import 'package:customer_booking/features/bookings/presentation/cubits/booking_cubit.dart';
import 'package:customer_booking/features/bookings/presentation/cubits/my_bookings_cubit.dart';
import 'package:customer_booking/features/credits/data/datasource/credits_remote_data_source.dart';
import 'package:customer_booking/features/credits/presentation/cubits/credits_cubit.dart';

class BookingInjection {
  static BookingRemoteDataSource? _bookingDataSource;
  static BookingRepository? _bookingRepository;
  static CreditsRemoteDataSource? _creditsDataSource;

  // Data Sources
  static BookingRemoteDataSource getBookingDataSource(ApiConsumer apiConsumer) {
    _bookingDataSource ??= BookingRemoteDataSourceImpl(
      apiConsumer: apiConsumer,
    );
    return _bookingDataSource!;
  }

  static CreditsRemoteDataSource getCreditsDataSource(ApiConsumer apiConsumer) {
    _creditsDataSource ??= CreditsRemoteDataSourceImpl(
      apiConsumer: apiConsumer,
    );
    return _creditsDataSource!;
  }

  // Repositories
  static BookingRepository getBookingRepository(ApiConsumer apiConsumer) {
    _bookingRepository ??= BookingRepositoryImpl(
      remoteDataSource: getBookingDataSource(apiConsumer),
    );
    return _bookingRepository!;
  }

  // Use Cases
  static CreateBookingUseCase getCreateBookingUseCase(ApiConsumer apiConsumer) {
    return CreateBookingUseCase(repository: getBookingRepository(apiConsumer));
  }

  static GetMyBookingsUseCase getGetMyBookingsUseCase(ApiConsumer apiConsumer) {
    return GetMyBookingsUseCase(repository: getBookingRepository(apiConsumer));
  }

  static CancelBookingUseCase getCancelBookingUseCase(ApiConsumer apiConsumer) {
    return CancelBookingUseCase(repository: getBookingRepository(apiConsumer));
  }

  // Cubits
  static BookingCubit getBookingCubit(ApiConsumer apiConsumer) {
    return BookingCubit(
      createBookingUseCase: getCreateBookingUseCase(apiConsumer),
    );
  }

  static MyBookingsCubit getMyBookingsCubit(ApiConsumer apiConsumer) {
    return MyBookingsCubit(
      getMyBookingsUseCase: getGetMyBookingsUseCase(apiConsumer),
      cancelBookingUseCase: getCancelBookingUseCase(apiConsumer),
    );
  }

  // Credits Cubit
  static CreditsCubit getCreditsCubit(ApiConsumer apiConsumer) {
    return CreditsCubit(dataSource: getCreditsDataSource(apiConsumer));
  }

  // User Profile Cubit
  static UserProfileCubit getUserProfileCubit(ApiConsumer apiConsumer) {
    return UserProfileCubit(apiConsumer: apiConsumer);
  }
}
