import 'package:customer_booking/core/presentation/main_navigation_screen.dart';
import 'package:customer_booking/core/services/api/dio_consumer.dart';
import 'package:customer_booking/core/services/auth_storage_service.dart';
import 'package:customer_booking/features/auth/data/datasource/auth_data_source.dart';
import 'package:customer_booking/features/auth/data/repo/auth_repo_imp.dart';
import 'package:customer_booking/features/auth/domain/usecases/login_usecase.dart';
import 'package:customer_booking/features/auth/domain/usecases/register_usecase.dart';
import 'package:customer_booking/features/auth/presentation/cubits/login/cubit/log_in_cubit.dart';
import 'package:customer_booking/features/auth/presentation/cubits/register/cubit/register_cubit.dart';
import 'package:customer_booking/features/auth/presentation/screens/login_screen.dart';
import 'package:customer_booking/features/auth/presentation/screens/register_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouters {
  static const String loginRoute = '/';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final isLoggedIn = await AuthStorageService.isLoggedIn();
      final isGoingToLogin = state.matchedLocation == loginRoute;
      final isGoingToRegister = state.matchedLocation == registerRoute;

      // If user is logged in and trying to access login/register, redirect to home
      if (isLoggedIn && (isGoingToLogin || isGoingToRegister)) {
        return homeRoute;
      }

      // If user is not logged in and trying to access home, redirect to login
      if (!isLoggedIn && state.matchedLocation == homeRoute) {
        return loginRoute;
      }

      // No redirect needed
      return null;
    },
    routes: [
      // Define your app routes here
      GoRoute(
        path: loginRoute,
        builder: (context, state) => BlocProvider(
          create: (context) => LogInCubit(
            LoginUseCase(
              AuthRepoImplementation(AuthDataSource(DioConsumer(dio: Dio()))),
            ),
          ),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: registerRoute,
        builder: (context, state) => BlocProvider(
          create: (context) => RegisterCubit(
            RegisterUseCase(
              AuthRepoImplementation(AuthDataSource(DioConsumer(dio: Dio()))),
            ),
          ),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: homeRoute,
        builder: (context, state) => const MainNavigationScreen(),
      ),
    ],
  );

  // Example method to clear authentication cache
  static void clearAuthCache() async {
    await AuthStorageService.clearToken();
  }
}
