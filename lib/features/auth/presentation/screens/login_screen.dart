import 'package:customer_booking/features/auth/presentation/cubits/login/cubit/log_in_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/login_header.dart';
import '../widgets/login_form.dart';
import '../widgets/signup_prompt.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  void _handleLogin(String email, String password) {
    context.read<LogInCubit>().logIn(email, password);
    setState(() {
      _isLoading = true;
    });
  }

  void _handleForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Forgot password feature coming soon')),
    );
  }

  void _handleSignUp() {
    // TODO: Navigate to sign up screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign up feature coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: BlocListener<LogInCubit, LogInState>(
          listener: (context, state) {
            if (state is LogInSuccess) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const LoginHeader(),
                LoginForm(
                  onLoginPressed: _handleLogin,
                  onForgotPasswordPressed: _handleForgotPassword,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 24),
                SignUpPrompt(onSignUpPressed: _handleSignUp),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
