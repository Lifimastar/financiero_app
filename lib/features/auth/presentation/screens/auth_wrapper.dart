import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/auth_providers.dart';
import '../screens/login_screen.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        // si 'user' no es nulo, el usuario esta autenticado
        if (user != null) {
          return const DashboardScreen();
        }
        // si 'user' es nulo, el usuario no esta autenticado
        return const LoginScreen();
      },
      // Mientras se espera la autenticacion
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text('Ocurrio un error: $error'))),
    );
  }
}
