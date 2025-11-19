import 'package:customer_booking/features/auth/presentation/screens/login_screen.dart';
import 'package:customer_booking/features/auth/presentation/screens/register_screen.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouters {
  static const String loginRoute = '/';
  static const String registerRoute = '/register';

  static final GoRouter router = GoRouter(
    initialLocation: '/',

    routes: [
      // Define your app routes here
      GoRoute(
        path: loginRoute,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: registerRoute,
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
  );

  // Example method to clear authentication cache
  static void clearAuthCache() {
    // Implement cache clearing logic here
  }
}
