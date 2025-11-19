import 'package:customer_booking/core/services/api/api_consumer.dart';
import 'package:customer_booking/core/services/api/dio_consumer.dart';
import 'package:customer_booking/features/home/data/datasource/session_remote_data_source.dart';
import 'package:customer_booking/features/home/data/repo/session_repository_impl.dart';
import 'package:customer_booking/features/home/domain/repo/session_repository.dart';
import 'package:customer_booking/features/home/domain/usecases/get_sessions_usecase.dart';
import 'package:customer_booking/features/home/presentation/cubits/home_cubit.dart';
import 'package:dio/dio.dart';

class HomeInjection {
  static late ApiConsumer _apiConsumer;
  static late BusinessRemoteDataSource _businessRemoteDataSource;
  static late BusinessRepository _businessRepository;
  static late GetBusinessesUseCase _getBusinessesUseCase;

  static void init() {
    // Initialize API Consumer
    _apiConsumer = DioConsumer(dio: Dio());

    // Initialize Data Source
    _businessRemoteDataSource = BusinessRemoteDataSourceImpl(
      apiConsumer: _apiConsumer,
    );

    // Initialize Repository
    _businessRepository = BusinessRepositoryImpl(
      remoteDataSource: _businessRemoteDataSource,
    );

    // Initialize Use Cases
    _getBusinessesUseCase = GetBusinessesUseCase(
      repository: _businessRepository,
    );
  }

  static HomeCubit getHomeCubit() {
    return HomeCubit(getBusinessesUseCase: _getBusinessesUseCase);
  }
}
