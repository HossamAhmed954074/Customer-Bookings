import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  void _handleLogin() {
    setState(() {
      _isLoading = true;
    });

    // TODO: Implement actual login logic with BLoC/Cubit
    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Navigate to home or show error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login functionality to be implemented'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  void _handleForgotPassword() {
    // TODO: Navigate to forgot password screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Forgot password feature coming soon'),
      ),
    );
  }

  void _handleSignUp() {
    // TODO: Navigate to sign up screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sign up feature coming soon'),
      ),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
              SignUpPrompt(
                onSignUpPressed: _handleSignUp,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
