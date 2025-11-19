import 'package:customer_booking/features/bookings/presentation/cubits/my_bookings_cubit.dart';
import 'package:customer_booking/features/bookings/presentation/cubits/my_bookings_state.dart';
import 'package:customer_booking/features/bookings/presentation/widgets/booking_card.dart';
import 'package:customer_booking/features/bookings/presentation/widgets/empty_bookings_widget.dart';
import 'package:customer_booking/core/presentation/tab_navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load bookings when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyBookingsCubit>().loadBookings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Bookings'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
            Tab(text: 'Cancelled'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<MyBookingsCubit>().refreshBookings();
            },
          ),
        ],
      ),
      body: BlocConsumer<MyBookingsCubit, MyBookingsState>(
        listener: (context, state) {
          if (state.status == MyBookingsStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Failed to load bookings'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == MyBookingsStatus.loading &&
              state.bookings.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            controller: _tabController,
            children: [
              // Upcoming bookings
              _BookingsList(
                bookings: state.upcomingBookings,
                emptyMessage: 'No upcoming bookings',
                emptySubmessage: 'Book a class to see it here',
                showCancelButton: true,
                onCancel: (bookingId) {
                  _showCancelConfirmation(context, bookingId);
                },
              ),

              // Past bookings
              _BookingsList(
                bookings: state.pastBookings,
                emptyMessage: 'No past bookings',
                emptySubmessage: 'Your completed classes will appear here',
                showCancelButton: false,
              ),

              // Cancelled bookings
              _BookingsList(
                bookings: state.cancelledBookings,
                emptyMessage: 'No cancelled bookings',
                emptySubmessage: 'Cancelled classes will appear here',
                showCancelButton: false,
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel Booking'),
        content: const Text(
          'Are you sure you want to cancel this booking? Your credits will be refunded.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('No, Keep It'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<MyBookingsCubit>().cancelBooking(bookingId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}

class _BookingsList extends StatelessWidget {
  final List<dynamic> bookings;
  final String emptyMessage;
  final String emptySubmessage;
  final bool showCancelButton;
  final Function(String)? onCancel;

  const _BookingsList({
    required this.bookings,
    required this.emptyMessage,
    required this.emptySubmessage,
    this.showCancelButton = false,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return EmptyBookingsWidget(
        message: emptyMessage,
        submessage: emptySubmessage,
        actionLabel: 'Browse Classes',
        onAction: () {
          // Switch to home tab (index 0)
          final tabNavigation = TabNavigationProvider.of(context);
          if (tabNavigation != null) {
            tabNavigation.onTabChange(0);
          } else {
            // Fallback: show message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Use the Home tab to browse classes'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return BookingCard(
          booking: booking,
          showCancelButton: showCancelButton,
          onCancel: showCancelButton && onCancel != null
              ? () => onCancel!(booking.id)
              : null,
          onTap: () {
            // TODO: Navigate to booking detail screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Booking details coming soon'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        );
      },
    );
  }
}
