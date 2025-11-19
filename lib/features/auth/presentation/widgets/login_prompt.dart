import 'package:flutter/material.dart';

class LoginPrompt extends StatelessWidget {
  final VoidCallback onLoginPressed;

  const LoginPrompt({super.key, required this.onLoginPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        GestureDetector(
          onTap: onLoginPressed,
          child: const Text(
            'Log In',
            style: TextStyle(
              color: Color(0xFF4C7EFF),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
