import 'package:dartz/dartz.dart';
import 'package:customer_booking/features/home/domain/entities/session.dart';
import 'package:customer_booking/features/home/domain/repo/session_repository.dart';

class GetBusinessesUseCase {
  final BusinessRepository repository;

  GetBusinessesUseCase({required this.repository});

  Future<Either<String, List<Business>>> call({
    double? latitude,
    double? longitude,
    double? radius,
    String? search,
  }) async {
    return await repository.getBusinesses(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      search: search,
    );
  }
}
