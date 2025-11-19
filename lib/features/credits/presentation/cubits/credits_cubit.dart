import 'package:customer_booking/features/credits/data/datasource/credits_remote_data_source.dart';
import 'package:customer_booking/features/credits/presentation/cubits/credits_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreditsCubit extends Cubit<CreditsState> {
  final CreditsRemoteDataSource dataSource;

  CreditsCubit({required this.dataSource}) : super(const CreditsState());

  Future<void> loadPackages() async {
    try {
      emit(state.copyWith(status: CreditsStatus.loading));

      debugPrint('Loading credit packages...');
      final packages = await dataSource.getCreditPackages();

      emit(
        state.copyWith(
          status: CreditsStatus.loaded,
          packages: packages.map((m) => m.toEntity()).toList(),
        ),
      );

      debugPrint('Loaded ${packages.length} credit packages');
    } catch (e) {
      debugPrint('Error loading credit packages: $e');
      emit(
        state.copyWith(status: CreditsStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> purchaseCredits(String packageId) async {
    try {
      emit(state.copyWith(status: CreditsStatus.purchasing));

      debugPrint('Purchasing credits for package: $packageId');
      final result = await dataSource.purchaseCredits(packageId);

      emit(
        state.copyWith(status: CreditsStatus.success, purchaseResult: result),
      );

      debugPrint('Credits purchased successfully');
    } catch (e) {
      debugPrint('Error purchasing credits: $e');
      emit(
        state.copyWith(status: CreditsStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void reset() {
    emit(const CreditsState());
  }
}
