import 'package:customer_booking/core/services/api/api_consumer.dart';
import 'package:customer_booking/core/services/auth_storage_service.dart';
import 'package:customer_booking/core/data/models/user_profile_model.dart';
import 'package:customer_booking/core/presentation/cubits/user_profile_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final ApiConsumer apiConsumer;

  UserProfileCubit({required this.apiConsumer}) : super(const UserProfileState());

  Future<void> loadProfile() async {
    try {
      emit(state.copyWith(status: UserProfileStatus.loading));

      final token = await AuthStorageService.getToken();
      debugPrint('=== LOADING USER PROFILE ===');
      debugPrint('Token exists: ${token != null}');
      debugPrint('Token: $token');
      
      // Use query parameter instead of header for this API
      final response = await apiConsumer.get(
        '/auth/me?token=$token',
      );

      debugPrint('=== PROFILE API RESPONSE ===');
      debugPrint('Response Type: ${response.data.runtimeType}');
      debugPrint('Response Data: ${response.data}');

      Map<String, dynamic> data;
      if (response.data is Map) {
        // Try different possible response structures
        if (response.data['user'] != null) {
          data = response.data['user'] as Map<String, dynamic>;
          debugPrint('Found user in response.data["user"]');
        } else if (response.data['data'] != null) {
          data = response.data['data'] as Map<String, dynamic>;
          debugPrint('Found user in response.data["data"]');
        } else {
          data = response.data as Map<String, dynamic>;
          debugPrint('Using response.data directly');
        }

        debugPrint('=== PARSING USER DATA ===');
        debugPrint('User ID: ${data['_id'] ?? data['id']}');
        debugPrint('User Name: ${data['name']}');
        debugPrint('User Email: ${data['email']}');
        debugPrint('User Credits: ${data['credits']}');

        final profile = UserProfileModel.fromJson(data).toEntity();
        
        debugPrint('=== PROFILE PARSED SUCCESSFULLY ===');
        debugPrint('Profile Credits: ${profile.credits}');
        
        emit(state.copyWith(
          status: UserProfileStatus.loaded,
          profile: profile,
        ));
      } else {
        debugPrint('✗ Response is not a Map');
        throw Exception('Invalid response format');
      }
    } catch (e, stackTrace) {
      debugPrint('=== ERROR LOADING PROFILE ===');
      debugPrint('Error: $e');
      debugPrint('StackTrace: $stackTrace');
      emit(state.copyWith(
        status: UserProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void updateCredits(int newCredits) {
    if (state.profile != null) {
      final updatedProfile = state.profile!.copyWith(credits: newCredits);
      emit(state.copyWith(profile: updatedProfile));
    }
  }

  void addCredits(int creditsToAdd) {
    if (state.profile != null) {
      final newCredits = state.profile!.credits + creditsToAdd;
      updateCredits(newCredits);
    }
  }

  void deductCredits(int creditsToDeduct) {
    if (state.profile != null) {
      final newCredits = state.profile!.credits - creditsToDeduct;
      updateCredits(newCredits);
    }
  }
}
