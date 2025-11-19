import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:customer_booking/features/home/domain/entities/session.dart';
import 'package:customer_booking/features/home/domain/usecases/get_sessions_usecase.dart';
import 'package:customer_booking/features/home/presentation/cubits/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetBusinessesUseCase getBusinessesUseCase;

  HomeCubit({required this.getBusinessesUseCase}) : super(const HomeState());

  final List<String> categories = ['All', 'Yoga', 'Pilates', 'HIIT', 'Dance'];

  Future<void> loadBusinesses({
    double? latitude,
    double? longitude,
    double? radius,
    String? search,
    String? locationName,
  }) async {
    emit(
      state.copyWith(
        status: HomeStatus.loading,
        userLatitude: latitude,
        userLongitude: longitude,
        radius: radius,
        searchQuery: search,
        locationName: locationName,
      ),
    );

    try {
      // Use default location (Los Angeles) if no location provided
      final lat = latitude ?? 34.052235;
      final lng = longitude ?? -118.243683;
      final searchRadius = radius ?? 5000.0;

      debugPrint(
        'Loading businesses: lat=$lat, lng=$lng, radius=$searchRadius',
      );

      final result = await getBusinessesUseCase(
        latitude: lat,
        longitude: lng,
        radius: searchRadius,
        search: search,
      );

      result.fold(
        (error) {
          debugPrint('Error loading businesses: $error');
          emit(
            state.copyWith(
              status: HomeStatus.error,
              errorMessage: 'Failed to load businesses: $error',
            ),
          );
        },
        (businesses) {
          debugPrint('Loaded ${businesses.length} businesses');
          emit(
            state.copyWith(
              status: HomeStatus.success,
              businesses: businesses,
              filteredBusinesses: _filterByCategory(
                businesses,
                state.selectedCategory,
              ),
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('Exception loading businesses: $e');
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: 'Unexpected error: $e',
        ),
      );
    }
  }

  void selectCategory(String category) {
    final selectedCategory = category == 'All' ? null : category;
    emit(
      state.copyWith(
        selectedCategory: selectedCategory,
        filteredBusinesses: _filterByCategory(
          state.businesses,
          selectedCategory,
        ),
      ),
    );
  }

  void searchBusinesses(String query) {
    loadBusinesses(
      latitude: state.userLatitude,
      longitude: state.userLongitude,
      radius: state.radius,
      search: query.isEmpty ? null : query,
    );
  }

  List<Business> _filterByCategory(
    List<Business> businesses,
    String? category,
  ) {
    if (category == null || category == 'All') {
      return businesses;
    }
    return businesses
        .where(
          (business) =>
              business.categories != null &&
              business.categories!.any(
                (cat) => cat.toLowerCase().contains(category.toLowerCase()),
              ),
        )
        .toList();
  }

  void refreshBusinesses() {
    loadBusinesses(
      latitude: state.userLatitude,
      longitude: state.userLongitude,
      radius: state.radius,
      search: state.searchQuery,
      locationName: state.locationName,
    );
  }

  void setLocation(double latitude, double longitude, String locationName) {
    loadBusinesses(
      latitude: latitude,
      longitude: longitude,
      radius: state.radius,
      search: state.searchQuery,
      locationName: locationName,
    );
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    searchBusinesses(query);
  }
}
