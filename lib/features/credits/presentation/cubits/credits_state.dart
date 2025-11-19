import 'package:customer_booking/features/credits/domain/entities/credit_package.dart';
import 'package:equatable/equatable.dart';

enum CreditsStatus { initial, loading, loaded, purchasing, success, error }

class CreditsState extends Equatable {
  final CreditsStatus status;
  final List<CreditPackage> packages;
  final String? errorMessage;
  final Map<String, dynamic>? purchaseResult;

  const CreditsState({
    this.status = CreditsStatus.initial,
    this.packages = const [],
    this.errorMessage,
    this.purchaseResult,
  });

  CreditsState copyWith({
    CreditsStatus? status,
    List<CreditPackage>? packages,
    String? errorMessage,
    Map<String, dynamic>? purchaseResult,
  }) {
    return CreditsState(
      status: status ?? this.status,
      packages: packages ?? this.packages,
      errorMessage: errorMessage,
      purchaseResult: purchaseResult,
    );
  }

  @override
  List<Object?> get props => [status, packages, errorMessage, purchaseResult];
}
