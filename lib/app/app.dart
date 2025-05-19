import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rctms/app/presentation/auth/screens/login_screen.dart';
import 'package:rctms/app/presentation/home/screens/home_screen.dart';
import 'package:rctms/app/providers/auth_providers.dart';
import 'package:rctms/app/theme.dart';

class RCTMSApp extends ConsumerStatefulWidget {
  const RCTMSApp({super.key});

  @override
  RCTMSAppState createState() => RCTMSAppState();
}

class RCTMSAppState extends ConsumerState<RCTMSApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).checkAuthStatus();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    return MaterialApp(
      title: 'RCTMS',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: authState.authStatus is AsyncLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : authState.isAuthenticated
          ? const HomeScreen()
          : const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}