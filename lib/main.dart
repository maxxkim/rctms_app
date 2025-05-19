// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rctms/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Register Hive adapters
  // Will be implemented later: registerAdapters();
  
  // Initialize services
  // Will be implemented later: await initializeServices();
  
  runApp(
    // Wrap the entire app with ProviderScope for Riverpod
    const ProviderScope(
      child: RCTMSApp(),
    ),
  );
}