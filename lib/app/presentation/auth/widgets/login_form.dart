import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rctms/app/presentation/home/screens/home_screen.dart';
import 'package:rctms/app/providers/auth_providers.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({Key? key}) : super(key: key);
  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    // Add this listener to handle auth state changes
    ref.listen<AuthState>(authProvider, (previous, current) {
      if (current.authStatus is AsyncError) {
        final error = (current.authStatus as AsyncError).error;
        
        // Extract error message based on error type
        String errorMessage = 'An error occurred';
        
        if (error is Exception) {
          // Handle specific exception types
          if (error.toString().contains('NetworkException')) {
            // For NetworkException, extract the message field
            errorMessage = error.toString().contains(':') 
                ? error.toString().split(':').last.trim() 
                : 'Connection error';
          } else if (error.toString().contains('ServerException')) {
            // For ServerException
            errorMessage = error.toString().contains(':') 
                ? error.toString().split(':').last.trim() 
                : 'Server error';
          } else if (error.toString().contains('AuthenticationException')) {
            // For AuthenticationException
            errorMessage = error.toString().contains(':') 
                ? error.toString().split(':').last.trim() 
                : 'Authentication failed';
          } else {
            // For other exceptions
            errorMessage = 'Login failed: Invalid credentials';
          }
        } else {
          // For non-exception errors
          errorMessage = error.toString();
        }
        
        // Set local error state
        setState(() {
          _errorMessage = errorMessage;
        });
        
        // Show SnackBar for immediate feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      } else if (current.isAuthenticated) {
        setState(() {
          _errorMessage = null;
        });
        
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@') || !value.contains('.')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          
          // Add visible error message
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          
          const SizedBox(height: 24),
          
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: authState.authStatus is AsyncLoading 
                ? null 
                : _login,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: authState.authStatus is AsyncLoading
                ? const CircularProgressIndicator()
                : const Text('Login', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
  
  void _login() {
    // Clear any previous error messages when attempting a new login
    setState(() {
      _errorMessage = null;
    });
    
    if (_formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }
}