import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reminder/state/auth/backend/authenticator.dart';
import 'package:reminder/state/auth/notifiers/models/auth_result.dart';
import 'package:reminder/state/auth/notifiers/models/auth_state.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final _authenticator = const Authenticator();
  AuthStateNotifier() : super(const AuthState.unknown()) {
    if (_authenticator.isAlreadyLoggedIn) {
      state = AuthState(
        result: AuthResult.success,
        isLoading: false,
        userId: _authenticator.userId,
      );
    }
  }

  Future<void> logOut() async {
    state = state.copiedWithIsLoading(true);
    await _authenticator.logOut();
    state = const AuthState.unknown();
  }

  Future<AuthResult> loginWithEmail(String email, String password) async {
    state = state.copiedWithIsLoading(true);
    final result = await _authenticator.loginWithEmail(email, password);
    final userId = _authenticator.userId;
    state = AuthState(
      result: result,
      isLoading: false,
      userId: userId,
    );
    return result;
  }

  Future<AuthResult> signUpWithEmail(
      String email, String password, String displayName) async {
    state = state.copiedWithIsLoading(true);
    final result =
        await _authenticator.signUpWithEmail(email, password, displayName);
    final userId = _authenticator.userId;
    state = AuthState(
      result: result,
      isLoading: false,
      userId: userId,
    );
    return result;
  }
}
