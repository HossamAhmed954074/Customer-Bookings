import 'package:dartz/dartz.dart';
import 'package:customer_booking/features/home/data/datasource/session_remote_data_source.dart';
import 'package:customer_booking/features/home/domain/entities/session.dart';
import 'package:customer_booking/features/home/domain/repo/session_repository.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  final BusinessRemoteDataSource remoteDataSource;

  BusinessRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<Business>>> getBusinesses({
    double? latitude,
    double? longitude,
    double? radius,
    String? search,
  }) async {
    try {
      final result = await remoteDataSource.getBusinesses(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        search: search,
      );

      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Business>> getBusinessDetail(String businessId) async {
    try {
      final result = await remoteDataSource.getBusinessDetail(businessId);
      return Right(result.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }
}
