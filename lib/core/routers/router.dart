import 'package:customer_booking/core/services/api/dio_consumer.dart';
import 'package:customer_booking/features/auth/data/datasource/auth_data_source.dart';
import 'package:customer_booking/features/auth/data/repo/auth_repo_imp.dart';
import 'package:customer_booking/features/auth/domain/usecases/login_usecase.dart';
import 'package:customer_booking/features/auth/presentation/cubits/login/cubit/log_in_cubit.dart';
import 'package:customer_booking/features/auth/presentation/screens/login_screen.dart';
import 'package:customer_booking/features/auth/presentation/screens/register_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
  );

  // Example method to clear authentication cache
  static void clearAuthCache() {
    // Implement cache clearing logic here
  }
}
