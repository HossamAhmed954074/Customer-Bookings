import 'package:dartz/dartz.dart';
import 'package:customer_booking/features/home/domain/entities/session.dart';
import 'package:customer_booking/features/home/domain/repo/session_repository.dart';

class GetBusinessDetailUseCase {
  final BusinessRepository repository;

  GetBusinessDetailUseCase({required this.repository});

  Future<Either<String, Business>> call(String businessId) async {
    return await repository.getBusinessDetail(businessId);
  }
}
