import 'package:customer_booking/features/bookings/presentation/cubits/booking_cubit.dart';
import 'package:customer_booking/features/bookings/presentation/cubits/booking_state.dart';
import 'package:customer_booking/features/bookings/presentation/widgets/booking_confirmation_dialog.dart';
import 'package:customer_booking/features/bookings/presentation/widgets/booking_form_widget.dart';
import 'package:customer_booking/features/home/domain/entities/session_entity.dart';
import 'package:customer_booking/core/presentation/cubits/user_profile_cubit.dart';
import 'package:customer_booking/core/presentation/cubits/user_profile_state.dart';
import 'package:customer_booking/features/credits/presentation/screens/purchase_credits_screen.dart';
import 'package:customer_booking/features/bookings/booking_injection.dart';
import 'package:customer_booking/core/services/api/dio_consumer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatelessWidget {
  final Session session;
  final String businessName;

  const BookingScreen({
    super.key,
    required this.session,
    required this.businessName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Book Class'),
        elevation: 0,
      ),
      body: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state.status == BookingStatus.success && state.booking != null) {
            // Show confirmation dialog after current frame
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => BookingConfirmationDialog(
                  booking: state.booking!,
                  onViewBookings: () {
                    // Navigate to My Bookings screen
                    Navigator.pop(context); // Close booking screen
                    // TODO: Navigate to My Bookings tab/screen
                  },
                ),
              );
            });
          } else if (state.status == BookingStatus.error) {
            // Show error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Failed to create booking'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Class information card
                _ClassInfoCard(
                  session: session,
                  businessName: businessName,
                ),
                const SizedBox(height: 24),

                // Divider
                const Divider(),
                const SizedBox(height: 24),

                // Booking form
                const Text(
                  'Complete Your Booking',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                BlocBuilder<UserProfileCubit, UserProfileState>(
                  builder: (context, profileState) {
                    // Show loading indicator while profile is loading
                    if (profileState.status == UserProfileStatus.loading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    // Show error if profile failed to load
                    if (profileState.status == UserProfileStatus.error) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              const Icon(Icons.error_outline, size: 48, color: Colors.red),
                              const SizedBox(height: 16),
                              Text(
                                'Failed to load profile: ${profileState.errorMessage}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<UserProfileCubit>().loadProfile();
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final userCredits = profileState.credits;
                    final hasEnoughCredits = userCredits >= session.credits;

                    return Column(
                      children: [
                        BookingFormWidget(
                          sessionName: session.name,
                          creditsRequired: session.credits,
                          userCredits: userCredits,
                          isLoading: state.status == BookingStatus.loading,
                          onConfirm: () {
                            context.read<BookingCubit>().createBooking(
                              sessionId: session.id,
                              notes: 'Excited to join!',
                            );
                            // Deduct credits after booking
                            context.read<UserProfileCubit>().deductCredits(session.credits);
                          },
                        ),
                        if (!hasEnoughCredits) ...[
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              final apiConsumer = DioConsumer(dio: Dio());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider.value(
                                        value: context.read<UserProfileCubit>(),
                                      ),
                                      BlocProvider(
                                        create: (_) => BookingInjection.getCreditsCubit(apiConsumer),
                                      ),
                                    ],
                                    child: const PurchaseCreditsScreen(),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_shopping_cart),
                            label: const Text('Purchase Credits'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ClassInfoCard extends StatelessWidget {
  final Session session;
  final String businessName;

  const _ClassInfoCard({
    required this.session,
    required this.businessName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              session.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Instructor
            Text(
              'with ${session.instructorName}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),

            const Divider(),
            const SizedBox(height: 12),

            // Location
            _InfoRow(
              icon: Icons.location_on,
              label: 'Location',
              value: businessName,
            ),
            const SizedBox(height: 12),

            // Date
            _InfoRow(
              icon: Icons.calendar_today,
              label: 'Date',
              value: DateFormat('EEEE, MMMM d, yyyy').format(session.date),
            ),
            const SizedBox(height: 12),

            // Time
            _InfoRow(
              icon: Icons.access_time,
              label: 'Time',
              value: '${session.startTime} - ${session.endTime}',
            ),
            const SizedBox(height: 12),

            // Duration
            _InfoRow(
              icon: Icons.timer,
              label: 'Duration',
              value: '${session.duration} minutes',
            ),
            const SizedBox(height: 12),

            // Capacity
            _InfoRow(
              icon: Icons.people,
              label: 'Available Spots',
              value: '${session.availableSpots} / ${session.capacity}',
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.fitness_center,
              label: 'Level',
              value: session.level,
            ),

            // Description
            if (session.description != null &&
                session.description!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'About This Class',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                session.description!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
