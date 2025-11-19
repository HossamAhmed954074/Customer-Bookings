import 'package:equatable/equatable.dart';
import 'package:customer_booking/features/home/domain/entities/session.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Business> businesses;
  final List<Business> filteredBusinesses;
  final String? selectedCategory;
  final String? errorMessage;
  final double? userLatitude;
  final double? userLongitude;
  final double radius; // Search radius in meters
  final String? searchQuery;

  const HomeState({
    this.status = HomeStatus.initial,
    this.businesses = const [],
    this.filteredBusinesses = const [],
    this.selectedCategory,
    this.errorMessage,
    this.userLatitude,
    this.userLongitude,
    this.radius = 5000, // Default 5km radius
    this.searchQuery,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<Business>? businesses,
    List<Business>? filteredBusinesses,
    String? selectedCategory,
    String? errorMessage,
    double? userLatitude,
    double? userLongitude,
    double? radius,
    String? searchQuery,
  }) {
    return HomeState(
      status: status ?? this.status,
      businesses: businesses ?? this.businesses,
      filteredBusinesses: filteredBusinesses ?? this.filteredBusinesses,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      errorMessage: errorMessage ?? this.errorMessage,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      radius: radius ?? this.radius,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    status,
    businesses,
    filteredBusinesses,
    selectedCategory,
    errorMessage,
    userLatitude,
    userLongitude,
    radius,
    searchQuery,
  ];
}
