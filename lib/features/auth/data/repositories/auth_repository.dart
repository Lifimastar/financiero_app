import 'package:firebase_auth/firebase_auth.dart';
import '../../data/datasources/auth_data_source.dart';

class AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepository(this._dataSource);

  Future<User?> signIn(String email, String password) =>
      _dataSource.signInWithEmailAndPassword(email, password);

  Future<User?> signUp(String email, String password) =>
      _dataSource.createUserWithEmailAndPassword(email, password);

  Future<void> signOut() => _dataSource.signOut();

  Stream<User?> get authStateChanges => _dataSource.authStateChanges;
}
