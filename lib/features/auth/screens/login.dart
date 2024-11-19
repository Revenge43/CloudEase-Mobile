import 'package:cloudease/core/constants/widgets.dart';
import 'package:cloudease/features/auth/data/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloudease/features/auth/widgets/auth_text_form_field.dart';
import 'package:cloudease/features/auth/decoration/wave.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isRegisterMode = false; // Toggle between login and register mode

  // Common validator function for text fields
  String? _requiredFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  void _submitForm() async {
    final authProvider = AuthProvider();
    var validated = _formKey.currentState?.validate() ?? false;
    if (validated) {
      isRegisterMode ? await _handleRegister(authProvider) : await _handleLogin(authProvider);
    }
  }

  Future<void> _handleRegister(AuthProvider authProvider) async {

    if (_formKey.currentState?.validate() ?? false) {

      try {
        final response = await authProvider.signUpUser(
          emailController.text,
          passwordController.text,
          nameController.text,
          Provider.of<AuthProvider>(context, listen: false).role,
        );
      if (response != null) {
        _showSnackBar('User signed up successfully');
      } else {}
      } catch (e) {
        _showSnackBar('Registration failed: $e');
      }
    }
  }

  Future<void> _handleLogin(AuthProvider authProvider) async {
    try {
      final response = await authProvider.loginUser(emailController.text, passwordController.text);
      if (response != null) {
        _navigateToHome();
      }
    } catch (e) {
        _showSnackBar('Login failed: $e');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      AppWidgets.showSnackBar(context, 'Login failed: $message');
    }
  }

  void _navigateToHome() {
    if (mounted) {
      context.go('/home');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Wave(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    if (isRegisterMode) 
                    AuthenticationTextFormField(
                      icon: Icons.person_add_alt,
                      label: 'Name',
                      textEditingController: nameController,
                      validator: _requiredFieldValidator,
                    ),
                    AuthenticationTextFormField(
                      icon: Icons.email,
                      label: 'Email',
                      textEditingController: emailController,
                      validator: _requiredFieldValidator,
                    ),
                    AuthenticationTextFormField(
                      icon: Icons.vpn_key,
                      label: 'Password',
                      textEditingController: passwordController,
                      validator: _requiredFieldValidator,
                    ),
                    if (isRegisterMode) 
                    AuthenticationTextFormField(
                      icon: Icons.password,
                      label: 'Password Confirmation',
                      textEditingController: passwordConfirmationController,
                      validator: (value) {
                        // Validate that the password matches
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    // RegisterFields(passwordConfirmationController: passwordConfirmationController),
                    const SizedBox(height: 25),
                    _buildSubmitButton(),
                    const SizedBox(height: 100),
                    _buildToggleModeText(),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Submit button for either login or register
  ElevatedButton _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: _submitForm,
      child: Text(isRegisterMode ? 'Register' : 'Login'),
    );
  }

  // Text to toggle between login and register mode
  InkWell _buildToggleModeText() {
    return InkWell(
      onTap: () {
        setState(() {
          isRegisterMode = !isRegisterMode;
        });
        _formKey.currentState?.reset(); // Reset form when switching modes
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isRegisterMode)
            Icon(
              Icons.arrow_back_ios_new,
              size: 14,
              color: Theme.of(context).primaryColor,
            ),
          const SizedBox(width: 8),
          Text(
            isRegisterMode
                ? 'Back to Login'
                : "Don't have an account? Register now",
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
