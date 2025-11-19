import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:customer_booking/features/home/domain/entities/session.dart';
import 'package:customer_booking/features/home/presentation/cubits/home_cubit.dart';
import 'package:customer_booking/features/home/presentation/cubits/home_state.dart';
import 'package:customer_booking/features/home/presentation/widgets/header_widget.dart';
import 'package:customer_booking/features/home/presentation/widgets/search_bar_widget.dart';
import 'package:customer_booking/features/home/presentation/widgets/map_section_widget.dart';
import 'package:customer_booking/features/home/presentation/widgets/businesses_list_widget.dart';
import 'package:customer_booking/features/home/presentation/widgets/location_filter_dialog.dart';
import 'package:customer_booking/features/home/presentation/widgets/category_filter_chip.dart';
import 'package:customer_booking/features/home/presentation/widgets/filter_button.dart';
import 'package:customer_booking/features/home/presentation/widgets/sessions_dialog.dart';
import 'package:customer_booking/features/home/data/datasource/session_remote_data_source.dart';
import 'package:customer_booking/core/services/api/dio_consumer.dart';
import 'package:dio/dio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  // Default location (Los Angeles as per API example)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(34.052235, -118.243683),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    // Load businesses when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().loadBusinesses();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _updateMarkers(List<Business> businesses) {
    _markers.clear();
    for (var business in businesses) {
      if (business.latitude != null && business.longitude != null) {
        _markers.add(
          Marker(
            markerId: MarkerId(business.id),
            position: LatLng(business.latitude!, business.longitude!),
            infoWindow: InfoWindow(
              title: business.name,
              snippet: business.address ?? business.distanceText,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            onTap: () {
              // Show sessions dialog when marker is tapped
              _showSessionsForBusiness(context, business);
            },
          ),
        );
      }
    }
  }

  void _showLocationFilter() {
    showDialog(
      context: context,
      builder: (dialogContext) => LocationFilterDialog(
        currentLocation: context.read<HomeCubit>().state.locationName,
        onLocationSelected: (lat, lng, locationName) {
          context.read<HomeCubit>().setLocation(lat, lng, locationName);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state.status == HomeStatus.success) {
              setState(() {
                _updateMarkers(state.filteredBusinesses);
              });
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Header with time and calendar icon
                      HeaderWidget(
                        onCalendarTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Calendar feature coming soon'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),

                      // Search bar with location filter
                      SearchBarWidget(
                        searchQuery: state.searchQuery ?? '',
                        onSearchChanged: (query) {
                          context.read<HomeCubit>().updateSearchQuery(query);
                        },
                        onLocationTap: _showLocationFilter,
                        locationText: state.locationName ?? 'Los Angeles, CA',
                      ),

                      const SizedBox(height: 16),

                      // Google Maps Section
                      MapSectionWidget(
                        state: state,
                        markers: _markers,
                        onMapCreated: _onMapCreated,
                        initialPosition: _initialPosition,
                      ),

                      // Category Filters
                      _buildCategoryFilters(state),
                    ],
                  ),
                ),

                // Businesses List
                SliverFillRemaining(
                  child: BusinessesListWidget(
                    state: state,
                    onBusinessTap: _showSessionsForBusiness,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(HomeState state) {
    final cubit = context.read<HomeCubit>();

    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: cubit.categories.length,
              itemBuilder: (context, index) {
                final category = cubit.categories[index];
                final isSelected =
                    state.selectedCategory == category ||
                    (category == 'All' && state.selectedCategory == null);

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CategoryFilterChip(
                    label: category,
                    isSelected: isSelected,
                    onTap: () => cubit.selectCategory(category),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilterButton(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Advanced filters coming soon'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showSessionsForBusiness(
    BuildContext context,
    Business business,
  ) async {
    debugPrint(
      'Fetching sessions for business: ${business.id} - ${business.name}',
    );

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading classes...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // Fetch sessions for this business
      final dataSource = BusinessRemoteDataSourceImpl(
        apiConsumer: DioConsumer(dio: Dio()),
      );

      final sessions = await dataSource.getSessionsForBusiness(
        businessId: business.id,
        dateFrom: DateTime.now(),
        dateTo: DateTime.now().add(const Duration(days: 7)),
      );

      debugPrint(
        'Received ${sessions.length} sessions for business ${business.name}',
      );

      // Close loading dialog
      if (context.mounted) Navigator.pop(context);

      // Show sessions dialog
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => SessionsDialog(
            businessName: business.name,
            sessions: sessions.map((m) => m.toEntity()).toList(),
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error fetching sessions: $e');
      debugPrint('Stack trace: $stackTrace');

      // Close loading dialog
      if (context.mounted) Navigator.pop(context);

      // Show error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load classes: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
