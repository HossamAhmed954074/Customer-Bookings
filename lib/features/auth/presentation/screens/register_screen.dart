import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/register_header.dart';
import '../widgets/register_form.dart';
import '../widgets/login_prompt.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;

  void _handleRegister() {
    setState(() {
      _isLoading = true;
    });

    // TODO: Implement actual registration logic with BLoC/Cubit
    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Navigate to verification screen or show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration functionality to be implemented'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  void _handleLogin() {
    // TODO: Navigate to login screen
    Navigator.of(context).pop();
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
          'Sign Up',
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
              const RegisterHeader(),
              RegisterForm(
                onRegisterPressed: _handleRegister,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 24),
              LoginPrompt(
                onLoginPressed: _handleLogin,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
