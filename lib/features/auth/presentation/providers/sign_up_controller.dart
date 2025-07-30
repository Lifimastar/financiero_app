import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository.dart';
import '../providers/auth_providers.dart';

final signUpLoadingProvider = StateProvider<bool>((ref) => false);

class SignUpController extends StateNotifier<bool> {
  final AuthRepository _authRepository;

  SignUpController(this._authRepository) : super(false);

  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    state = true;
    try {
      await _authRepository.signUp(email, password);
      state = false;
      return true;
    } catch (e) {
      print(e);
      state = false;
      return false;
    }
  }
}

final signUpControllerProvider = StateNotifierProvider<SignUpController, bool>((
  ref,
) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignUpController(authRepository);
});
