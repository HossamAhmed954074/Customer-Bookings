import 'package:customer_booking/core/services/api/api_consumer.dart';
import 'package:customer_booking/features/home/data/models/session_model.dart';
import 'package:customer_booking/features/home/data/models/session_model_entity.dart';
import 'package:flutter/foundation.dart';

abstract class BusinessRemoteDataSource {
  Future<List<BusinessModel>> getBusinesses({
    double? latitude,
    double? longitude,
    double? radius,
    String? search,
  });

  Future<BusinessModel> getBusinessDetail(String businessId);

  Future<List<SessionModel>> getSessionsForBusiness({
    required String businessId,
    DateTime? dateFrom,
    DateTime? dateTo,
  });
}

class BusinessRemoteDataSourceImpl implements BusinessRemoteDataSource {
  final ApiConsumer apiConsumer;

  BusinessRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<BusinessModel>> getBusinesses({
    double? latitude,
    double? longitude,
    double? radius,
    String? search,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {};

      if (latitude != null) {
        queryParameters['lat'] = latitude;
      }
      if (longitude != null) {
        queryParameters['lng'] = longitude;
      }
      if (radius != null) {
        queryParameters['radius'] = radius;
      }
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }

      debugPrint('=== BUSINESSES API REQUEST ===');
      debugPrint('Endpoint: /businesses');
      debugPrint('Query Parameters: $queryParameters');

      final response = await apiConsumer.get(
        "/businesses",
        queryParameters: queryParameters,
      );

      debugPrint('=== BUSINESSES API RESPONSE ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Type: ${response.data.runtimeType}');
      debugPrint('Response Data: ${response.data}');

      // Handle response with items array
      List<dynamic> dataList;
      if (response.data is List) {
        dataList = response.data as List;
        debugPrint('✓ Response is direct array with ${dataList.length} items');
      } else if (response.data is Map && response.data['items'] != null) {
        dataList = response.data['items'] as List;
        debugPrint('✓ Response has items array with ${dataList.length} items');
      } else if (response.data is Map && response.data['data'] != null) {
        dataList = response.data['data'] as List;
        debugPrint('✓ Response has nested data with ${dataList.length} items');
      } else {
        debugPrint('✗ Unexpected response format');
        debugPrint(
          'Response keys: ${response.data is Map ? (response.data as Map).keys : "not a map"}',
        );
        return [];
      }

      final businesses = dataList
          .map((json) {
            try {
              return BusinessModel.fromJson(json);
            } catch (e) {
              debugPrint('Error parsing business: $e');
              debugPrint('Business JSON: $json');
              return null;
            }
          })
          .whereType<BusinessModel>()
          .toList();

      debugPrint('✓ Successfully parsed ${businesses.length} businesses');
      return businesses;
    } catch (e, stack) {
      debugPrint('=== ERROR IN getBusinesses ===');
      debugPrint('Error: $e');
      debugPrint('Stack: $stack');
      rethrow;
    }
  }

  @override
  Future<BusinessModel> getBusinessDetail(String businessId) async {
    try {
      debugPrint('=== BUSINESS DETAIL API REQUEST ===');
      debugPrint('Business ID: $businessId');

      final response = await apiConsumer.get('/businesses/$businessId');

      debugPrint('=== BUSINESS DETAIL API RESPONSE ===');
      debugPrint('Response Data: ${response.data}');

      // Handle both direct object and nested data property
      Map<String, dynamic> data;
      if (response.data is Map) {
        if (response.data['data'] != null) {
          data = response.data['data'] as Map<String, dynamic>;
        } else {
          data = response.data as Map<String, dynamic>;
        }
        return BusinessModel.fromJson(data);
      }

      throw Exception('Business not found');
    } catch (e, stack) {
      debugPrint('=== ERROR IN getBusinessDetail ===');
      debugPrint('Error: $e');
      debugPrint('Stack: $stack');
      rethrow;
    }
  }

  @override
  Future<List<SessionModel>> getSessionsForBusiness({
    required String businessId,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {'businessId': businessId};

      if (dateFrom != null) {
        queryParameters['dateFrom'] = dateFrom.toIso8601String().split('T')[0];
      }
      if (dateTo != null) {
        queryParameters['dateTo'] = dateTo.toIso8601String().split('T')[0];
      }

      debugPrint('=== SESSIONS API REQUEST ===');
      debugPrint('Business ID: $businessId');
      debugPrint('Query Parameters: $queryParameters');

      final response = await apiConsumer.get(
        "/sessions",
        queryParameters: queryParameters,
      );

      debugPrint('=== SESSIONS API RESPONSE ===');
      debugPrint('Response Type: ${response.data.runtimeType}');
      debugPrint('Response Data: ${response.data}');

      // Handle response with items array
      List<dynamic> dataList;
      if (response.data is List) {
        dataList = response.data as List;
        debugPrint('✓ Response is direct array with ${dataList.length} items');
      } else if (response.data is Map && response.data['items'] != null) {
        dataList = response.data['items'] as List;
        debugPrint('✓ Response has items array with ${dataList.length} items');
      } else if (response.data is Map && response.data['data'] != null) {
        dataList = response.data['data'] as List;
        debugPrint('✓ Response has data array with ${dataList.length} items');
      } else {
        debugPrint('✗ Unexpected response format');
        return [];
      }

      final sessions = dataList
          .map((json) {
            try {
              return SessionModel.fromJson(json);
            } catch (e) {
              debugPrint('Error parsing session: $e');
              debugPrint('Session JSON: $json');
              return null;
            }
          })
          .whereType<SessionModel>()
          .toList();

      debugPrint('✓ Successfully parsed ${sessions.length} sessions');
      return sessions;
    } catch (e, stack) {
      debugPrint('=== ERROR IN getSessionsForBusiness ===');
      debugPrint('Error: $e');
      debugPrint('Stack: $stack');
      rethrow;
    }
  }
}
