import 'package:customer_booking/core/routers/router.dart';
import 'package:customer_booking/features/home/home_injection.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Warning: .env file not found - $e");
  }

  // Initialize Home feature dependencies
  HomeInjection.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Customer Booking',
      theme: ThemeData.light(),
      routerConfig: AppRouters.router,
    );
  }
}
