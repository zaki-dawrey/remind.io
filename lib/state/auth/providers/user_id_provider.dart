import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reminder/state/auth/providers/auth_state_provider.dart';
import 'package:reminder/state/constants/typedefs/user_id.dart';

final userIdProvider = Provider<UserId?>(
  (ref) => ref.watch(authStateProvider).userId,
);
