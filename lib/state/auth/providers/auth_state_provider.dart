import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reminder/state/auth/notifiers/auth_state_notifier.dart';
import 'package:reminder/state/auth/notifiers/models/auth_state.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (_) => AuthStateNotifier(),
);
