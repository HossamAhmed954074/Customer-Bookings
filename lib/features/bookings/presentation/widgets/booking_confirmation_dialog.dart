import 'package:customer_booking/features/bookings/domain/entities/booking_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingConfirmationDialog extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback? onViewBookings;

  const BookingConfirmationDialog({
    super.key,
    required this.booking,
    this.onViewBookings,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 64,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                'Booking Confirmed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Your class has been successfully booked',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              // Booking details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _DetailRow(
                      icon: Icons.fitness_center,
                      label: 'Class',
                      value: booking.sessionName,
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.location_on,
                      label: 'Location',
                      value: booking.businessName,
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.calendar_today,
                      label: 'Date',
                      value: DateFormat(
                        'EEE, MMM d, yyyy',
                      ).format(booking.sessionDate),
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.access_time,
                      label: 'Time',
                      value:
                          '${booking.sessionStartTime} - ${booking.sessionEndTime}',
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.stars,
                      label: 'Credits Used',
                      value: '${booking.credits}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action buttons
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (onViewBookings != null) {
                        onViewBookings!();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'View My Bookings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
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
