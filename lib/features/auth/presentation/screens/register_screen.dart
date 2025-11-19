import 'package:customer_booking/features/auth/presentation/cubits/register/cubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  void _handleRegister(
    String fullName,
    String email,
    String phone,
    String password,
    String confirmPassword,
  ) {
    setState(() {
      context.read<RegisterCubit>().register(fullName, password, email, phone);

      _isLoading = true;
    });
  }

  void _handleLogin() {
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
        child: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              setState(() {
                _isLoading = false;
              });
              Navigator.of(context).pop();
            } else if (state is RegisterFailure) {
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
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
                LoginPrompt(onLoginPressed: _handleLogin),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
