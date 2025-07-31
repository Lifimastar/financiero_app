import 'package:financiero_app/features/auth/presentation/screens/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:financiero_app/firebase_options.dart';
import 'core/database/isar_service.dart';

final isarServiceProvider = Provider<IsarService>((ref) => IsarService());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isarService = IsarService();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ProviderScope(
      overrides: [isarServiceProvider.overrideWithValue(isarService)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financiero App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
    );
  }
}
