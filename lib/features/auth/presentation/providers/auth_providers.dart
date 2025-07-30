import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/auth_data_source.dart';
import '../../data/repositories/auth_repository.dart';

// Provider para el DataSource
final authDataSourceProvider = Provider((ref) => AuthDataSource());

// Provider para el Repositorio
final authRepositoryProvider = Provider((ref) {
  return AuthRepository(ref.watch(authDataSourceProvider));
});

// StreamProvider para escuchar el estado de la autenticacion en tiempo real
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
