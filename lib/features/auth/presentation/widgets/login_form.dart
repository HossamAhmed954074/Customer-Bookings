import 'package:flutter/material.dart';
import 'custom_text_field.dart';
import 'primary_button.dart';

class LoginForm extends StatefulWidget {
  final Function(String , String) onLoginPressed;
  final VoidCallback onForgotPasswordPressed;
  final bool isLoading;

  const LoginForm({
    super.key,
    required this.onLoginPressed,
    required this.onForgotPasswordPressed,
    this.isLoading = false,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      widget.onLoginPressed( _emailController.text.trim(), _passwordController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            hintText: 'Email',
            prefixIcon: Icons.email_outlined,
            controller: _emailController,
            validator: _validateEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Password',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
            controller: _passwordController,
            validator: _validatePassword,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.onForgotPasswordPressed,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: Color(0xFF4C7EFF),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Log In',
            onPressed: _handleLogin,
            isLoading: widget.isLoading,
          ),
        ],
      ),
    );
  }
}
