import 'package:customer_booking/core/services/api/api_consumer.dart';
import 'package:customer_booking/core/services/auth_storage_service.dart';
import 'package:customer_booking/features/bookings/data/models/booking_model.dart';
import 'package:customer_booking/features/bookings/domain/entities/create_booking_request.dart';
import 'package:flutter/foundation.dart';

abstract class BookingRemoteDataSource {
  Future<BookingModel> createBooking(CreateBookingRequest request);
  Future<List<BookingModel>> getMyBookings({String? status});
  Future<BookingModel> getBookingById(String bookingId);
  Future<BookingModel> cancelBooking(String bookingId);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiConsumer apiConsumer;

  BookingRemoteDataSourceImpl({required this.apiConsumer});

  Future<Map<String, String>> _getAuthHeaders(String? idempotencyKey) async {
    final token = await AuthStorageService.getToken();
    final headers = {'Authorization': 'Bearer ${token ?? ""}'};
    if (idempotencyKey != null) {
      headers['Idempotency-Key'] = idempotencyKey;
    }
    return headers;
  }

  @override
  Future<BookingModel> createBooking(CreateBookingRequest request) async {
    try {
      debugPrint('=== CREATE BOOKING API REQUEST ===');
      debugPrint('Request: ${request.toJson()}');
      debugPrint('Idempotency Key: ${request.idempotencyKey}');
      debugPrint('Headers: $request.headers');
      final response = await apiConsumer.post(
        '/bookings',
        data: request.toJson(),
        headers: await _getAuthHeaders(request.idempotencyKey),
      );

      debugPrint('=== CREATE BOOKING API RESPONSE ===');
      debugPrint('Response Data: ${response.data}');

      // Handle response
      Map<String, dynamic> data;
      if (response.data is Map) {
        if (response.data['data'] != null) {
          data = response.data['data'] as Map<String, dynamic>;
        } else if (response.data['booking'] != null) {
          data = response.data['booking'] as Map<String, dynamic>;
        } else {
          data = response.data as Map<String, dynamic>;
        }
        return BookingModel.fromJson(data);
      }

      throw Exception('Invalid response format');
    } catch (e, stack) {
      debugPrint('=== ERROR IN createBooking ===');
      debugPrint('Error: $e');
      debugPrint('Stack: $stack');
      rethrow;
    }
  }

  @override
  Future<List<BookingModel>> getMyBookings({String? status}) async {
    try {
      final Map<String, dynamic> queryParameters = {};
      if (status != null) {
        queryParameters['status'] = status;
      }

      debugPrint('=== GET MY BOOKINGS API REQUEST ===');
      debugPrint('Query Parameters: $queryParameters');

      final response = await apiConsumer.get(
        '/bookings',
        queryParameters: queryParameters,
        headers: await _getAuthHeaders(null),
      );

      debugPrint('=== GET MY BOOKINGS API RESPONSE ===');
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
      } else if (response.data is Map && response.data['bookings'] != null) {
        dataList = response.data['bookings'] as List;
        debugPrint(
          '✓ Response has bookings array with ${dataList.length} items',
        );
      } else {
        debugPrint('✗ Unexpected response format');
        return [];
      }

      final bookings = dataList
          .map((json) {
            try {
              return BookingModel.fromJson(json);
            } catch (e) {
              debugPrint('Error parsing booking: $e');
              debugPrint('Booking JSON: $json');
              return null;
            }
          })
          .whereType<BookingModel>()
          .toList();

      debugPrint('✓ Successfully parsed ${bookings.length} bookings');
      return bookings;
    } catch (e, stack) {
      debugPrint('=== ERROR IN getMyBookings ===');
      debugPrint('Error: $e');
      debugPrint('Stack: $stack');
      rethrow;
    }
  }

  @override
  Future<BookingModel> getBookingById(String bookingId) async {
    try {
      debugPrint('=== GET BOOKING BY ID API REQUEST ===');
      debugPrint('Booking ID: $bookingId');

      final response = await apiConsumer.get(
        '/bookings/$bookingId',
        headers: await _getAuthHeaders(null),
      );

      debugPrint('=== GET BOOKING BY ID API RESPONSE ===');
      debugPrint('Response Data: ${response.data}');

      // Handle both direct object and nested data property
      Map<String, dynamic> data;
      if (response.data is Map) {
        if (response.data['data'] != null) {
          data = response.data['data'] as Map<String, dynamic>;
        } else if (response.data['booking'] != null) {
          data = response.data['booking'] as Map<String, dynamic>;
        } else {
          data = response.data as Map<String, dynamic>;
        }
        return BookingModel.fromJson(data);
      }

      throw Exception('Booking not found');
    } catch (e, stack) {
      debugPrint('=== ERROR IN getBookingById ===');
      debugPrint('Error: $e');
      debugPrint('Stack: $stack');
      rethrow;
    }
  }

  @override
  Future<BookingModel> cancelBooking(String bookingId) async {
    try {
      debugPrint('=== CANCEL BOOKING API REQUEST ===');
      debugPrint('Booking ID: $bookingId');

      final response = await apiConsumer.delete(
        '/bookings/$bookingId',
        headers: await _getAuthHeaders(null),
      );

      debugPrint('=== CANCEL BOOKING API RESPONSE ===');
      debugPrint('Response Data: ${response.data}');

      // Handle response
      Map<String, dynamic> data;
      if (response.data is Map) {
        if (response.data['data'] != null) {
          data = response.data['data'] as Map<String, dynamic>;
        } else if (response.data['booking'] != null) {
          data = response.data['booking'] as Map<String, dynamic>;
        } else {
          data = response.data as Map<String, dynamic>;
        }
        return BookingModel.fromJson(data);
      }

      throw Exception('Failed to cancel booking');
    } catch (e, stack) {
      debugPrint('=== ERROR IN cancelBooking ===');
      debugPrint('Error: $e');
      debugPrint('Stack: $stack');
      rethrow;
    }
  }
}
