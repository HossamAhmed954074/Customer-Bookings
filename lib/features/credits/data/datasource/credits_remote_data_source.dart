import 'package:customer_booking/core/services/api/api_consumer.dart';
import 'package:customer_booking/core/services/auth_storage_service.dart';
import 'package:customer_booking/features/credits/data/models/credit_package_model.dart';
import 'package:flutter/foundation.dart';

abstract class CreditsRemoteDataSource {
  Future<List<CreditPackageModel>> getCreditPackages();
  Future<Map<String, dynamic>> purchaseCredits(String packageId);
}

class CreditsRemoteDataSourceImpl implements CreditsRemoteDataSource {
  final ApiConsumer apiConsumer;

  CreditsRemoteDataSourceImpl({required this.apiConsumer});

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await AuthStorageService.getToken();
    return {
      'Authorization': 'Bearer ${token ?? ""}',
    };
  }

  @override
  Future<List<CreditPackageModel>> getCreditPackages() async {
    try {
      debugPrint('=== GET CREDIT PACKAGES API REQUEST ===');

      final response = await apiConsumer.get('/credits/packages');

      debugPrint('=== GET CREDIT PACKAGES API RESPONSE ===');
      debugPrint('Response Type: ${response.data.runtimeType}');
      debugPrint('Response Data: ${response.data}');

      // Handle response with items array
      List<dynamic> dataList;
      if (response.data is List) {
        dataList = response.data as List;
      } else if (response.data is Map && response.data['items'] != null) {
        dataList = response.data['items'] as List;
      } else if (response.data is Map && response.data['data'] != null) {
        dataList = response.data['data'] as List;
      } else if (response.data is Map && response.data['packages'] != null) {
        dataList = response.data['packages'] as List;
      } else {
        debugPrint('✗ Unexpected response format');
        return [];
      }

      final packages = dataList
          .map((json) {
            try {
              return CreditPackageModel.fromJson(json);
            } catch (e) {
              debugPrint('Error parsing credit package: $e');
              return null;
            }
          })
          .whereType<CreditPackageModel>()
          .toList();

      debugPrint('✓ Successfully parsed ${packages.length} credit packages');
      return packages;
    } catch (e, stack) {
      debugPrint('=== ERROR IN getCreditPackages ===');
      debugPrint('Error: $e');
      debugPrint('Stack: $stack');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> purchaseCredits(String packageId) async {
    try {
      debugPrint('=== PURCHASE CREDITS API REQUEST ===');
      debugPrint('Package ID: $packageId');

      final response = await apiConsumer.post(
        '/credits/purchase',
        data: {'packageId': packageId},
        headers: await _getAuthHeaders(),
      );

      debugPrint('=== PURCHASE CREDITS API RESPONSE ===');
      debugPrint('Response Data: ${response.data}');

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }

      return {'success': true};
    } catch (e, stack) {
      debugPrint('=== ERROR IN purchaseCredits ===');
      debugPrint('Error: $e');
      debugPrint('Stack: $stack');
      rethrow;
    }
  }
}
