import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:customer_booking/features/home/domain/entities/session.dart';
import 'package:customer_booking/features/home/presentation/cubits/home_cubit.dart';
import 'package:customer_booking/features/home/presentation/cubits/home_state.dart';
import 'package:customer_booking/features/home/presentation/widgets/category_filter_chip.dart';
import 'package:customer_booking/features/home/presentation/widgets/session_card.dart';
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
          ),
        );
      }
    }
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
            return Column(
              children: [
                // Header with time and calendar icon
                _buildHeader(),

                // Google Maps Section
                _buildMapSection(state),

                // Category Filters
                _buildCategoryFilters(state),

                // Businesses List
                Expanded(child: _buildBusinessesList(state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time, size: 20),
              const SizedBox(width: 8),
              Text(
                '${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.calendar_today, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection(HomeState state) {
    return Container(
      height: 250,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: _initialPosition,
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
            if (state.status == HomeStatus.loading)
              Container(
                color: Colors.white.withOpacity(0.7),
                child: const Center(child: CircularProgressIndicator()),
              ),
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Text(
                  'Google Map Mock',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          ],
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
                // TODO: Show filter dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Filter dialog coming soon'),
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

  Widget _buildBusinessesList(HomeState state) {
    // Debug: Show what state we're in
    debugPrint(
      'Building businesses list - Status: ${state.status}, Businesses: ${state.businesses.length}, Filtered: ${state.filteredBusinesses.length}',
    );

    if (state.status == HomeStatus.loading && state.businesses.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading businesses...'),
          ],
        ),
      );
    }

    if (state.status == HomeStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                state.errorMessage ?? 'An error occurred',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<HomeCubit>().refreshBusinesses(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.filteredBusinesses.isEmpty &&
        state.status == HomeStatus.success) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.store_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No businesses found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              state.selectedCategory != null
                  ? 'Try selecting a different category'
                  : 'Try adjusting your search location',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<HomeCubit>().refreshBusinesses(),
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: state.filteredBusinesses.length,
      itemBuilder: (context, index) {
        final business = state.filteredBusinesses[index];
        return BusinessCard(
          business: business,
          onTap: () => _showSessionsForBusiness(context, business),
        );
      },
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
