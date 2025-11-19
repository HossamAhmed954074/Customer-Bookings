import 'package:flutter/material.dart';

class SignUpPrompt extends StatelessWidget {
  final VoidCallback onSignUpPressed;

  const SignUpPrompt({super.key, required this.onSignUpPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        GestureDetector(
          onTap: onSignUpPressed,
          child: const Text(
            'Sign Up',
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
