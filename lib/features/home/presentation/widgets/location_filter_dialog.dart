import 'package:flutter/material.dart';

class LocationFilterDialog extends StatefulWidget {
  final String? currentLocation;
  final Function(double lat, double lng, String locationName)
  onLocationSelected;

  const LocationFilterDialog({
    super.key,
    this.currentLocation,
    required this.onLocationSelected,
  });

  @override
  State<LocationFilterDialog> createState() => _LocationFilterDialogState();
}

class _LocationFilterDialogState extends State<LocationFilterDialog> {
  final TextEditingController _searchController = TextEditingController();

  // Popular locations
  final List<Map<String, dynamic>> _popularLocations = [
    {'name': 'Los Angeles, CA', 'lat': 34.052235, 'lng': -118.243683},
    {'name': 'New York, NY', 'lat': 40.712776, 'lng': -74.005974},
    {'name': 'Chicago, IL', 'lat': 41.878113, 'lng': -87.629799},
    {'name': 'Houston, TX', 'lat': 29.760427, 'lng': -95.369804},
    {'name': 'Phoenix, AZ', 'lat': 33.448376, 'lng': -112.074036},
    {'name': 'San Francisco, CA', 'lat': 37.774929, 'lng': -122.419418},
  ];

  List<Map<String, dynamic>> _filteredLocations = [];

  @override
  void initState() {
    super.initState();
    _filteredLocations = _popularLocations;
    _searchController.addListener(_filterLocations);
  }

  void _filterLocations() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredLocations = _popularLocations;
      } else {
        _filteredLocations = _popularLocations
            .where(
              (loc) => loc['name'].toString().toLowerCase().contains(query),
            )
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.blue[700]),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Select Location',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Search field
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search location...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),

            // Current location button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.my_location, color: Colors.green[700]),
                ),
                title: const Text(
                  'Use Current Location',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Get nearby businesses'),
                onTap: () {
                  // Use default Los Angeles location
                  widget.onLocationSelected(
                    34.052235,
                    -118.243683,
                    'Current Location',
                  );
                  Navigator.pop(context);
                },
              ),
            ),

            const Divider(),

            // Locations list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredLocations.length,
                itemBuilder: (context, index) {
                  final location = _filteredLocations[index];
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.location_city, color: Colors.blue[700]),
                    ),
                    title: Text(
                      location['name'],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      widget.onLocationSelected(
                        location['lat'],
                        location['lng'],
                        location['name'],
                      );
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
