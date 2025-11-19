import 'package:dartz/dartz.dart';
import 'package:customer_booking/features/home/domain/entities/session.dart';

abstract class BusinessRepository {
  Future<Either<String, List<Business>>> getBusinesses({
    double? latitude,
    double? longitude,
    double? radius,
    String? search,
  });

  Future<Either<String, Business>> getBusinessDetail(String businessId);
}
