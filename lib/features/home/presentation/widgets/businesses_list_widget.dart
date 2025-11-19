import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:customer_booking/features/home/domain/entities/session.dart';
import 'package:customer_booking/features/home/presentation/cubits/home_cubit.dart';
import 'package:customer_booking/features/home/presentation/cubits/home_state.dart';
import 'package:customer_booking/features/home/presentation/widgets/session_card.dart';

class BusinessesListWidget extends StatelessWidget {
  final HomeState state;
  final Function(BuildContext, Business) onBusinessTap;

  const BusinessesListWidget({
    super.key,
    required this.state,
    required this.onBusinessTap,
  });

  @override
  Widget build(BuildContext context) {
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
                  : 'Try adjusting your search or location',
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
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final business = state.filteredBusinesses[index];
        return BusinessCard(
          business: business,
          onTap: () => onBusinessTap(context, business),
        );
      },
    );
  }
}
