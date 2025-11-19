import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:customer_booking/features/home/domain/entities/session_entity.dart';
import 'package:customer_booking/features/bookings/presentation/screens/booking_screen.dart';
import 'package:customer_booking/features/bookings/booking_injection.dart';
import 'package:customer_booking/core/services/api/dio_consumer.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class SessionsDialog extends StatelessWidget {
  final String businessName;
  final List<Session> sessions;

  const SessionsDialog({
    super.key,
    required this.businessName,
    required this.sessions,
  });

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
                color: Colors.blue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Available Classes',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          businessName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Sessions List
            if (sessions.isEmpty)
              const Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No classes available',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Check back later for new classes',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return _SessionItem(
                      session: session,
                      businessName: businessName,
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

class _SessionItem extends StatelessWidget {
  final Session session;
  final String businessName;

  const _SessionItem({
    required this.session,
    required this.businessName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: session.hasAvailableSpots
              ? () {
                  // Navigate to booking screen
                  final apiConsumer = DioConsumer(dio: Dio());
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (_) =>
                                BookingInjection.getBookingCubit(apiConsumer),
                          ),
                          BlocProvider(
                            create: (_) =>
                                BookingInjection.getUserProfileCubit(apiConsumer)
                                  ..loadProfile(),
                          ),
                        ],
                        child: BookingScreen(
                          session: session,
                          businessName: businessName,
                        ),
                      ),
                    ),
                  );
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Class Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getClassColor(session.name).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getClassIcon(session.name),
                        color: _getClassColor(session.name),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Class Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            session.instructorName,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Availability Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: session.hasAvailableSpots
                            ? Colors.green
                            : Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        session.hasAvailableSpots
                            ? '${session.availableSpots} spots'
                            : 'Full',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Session Details
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('EEE, MMM dd').format(session.date),
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      '${session.startTime} - ${session.endTime}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(
                      Icons.fitness_center,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '${session.duration} min',
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.stars, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '${session.credits} credits',
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        session.level.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getClassIcon(String className) {
    final name = className.toLowerCase();
    if (name.contains('yoga')) return Icons.self_improvement;
    if (name.contains('pilates')) return Icons.accessibility_new;
    if (name.contains('hiit') || name.contains('cardio')) return Icons.flash_on;
    if (name.contains('dance')) return Icons.music_note;
    if (name.contains('spin') || name.contains('cycle'))
      return Icons.pedal_bike;
    return Icons.fitness_center;
  }

  Color _getClassColor(String className) {
    final name = className.toLowerCase();
    if (name.contains('yoga')) return Colors.purple;
    if (name.contains('pilates')) return Colors.pink;
    if (name.contains('hiit') || name.contains('cardio')) return Colors.orange;
    if (name.contains('dance')) return Colors.teal;
    if (name.contains('spin') || name.contains('cycle')) return Colors.blue;
    return Colors.green;
  }
}
