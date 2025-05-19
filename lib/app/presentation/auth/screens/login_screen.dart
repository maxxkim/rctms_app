// lib/presentation/auth/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:rctms/app/presentation/auth/screens/register_screen.dart';
import 'package:rctms/app/presentation/auth/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RCTMS Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or app name
                const Icon(
                  Icons.task_alt,
                  size: 80,
                  color: Colors.deepPurpleAccent,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Realtime Collaborative\nTask Management System',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Login form
                const LoginForm(),
                const SizedBox(height: 24),
                // Register link
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text('Don\'t have an account? Register here'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}