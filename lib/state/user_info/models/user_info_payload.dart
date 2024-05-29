import 'package:flutter/foundation.dart' show immutable;
import 'package:reminder/state/constants/typedefs/user_id.dart';

@immutable
class UserInfoPayload {
  final UserId userId;
  final String displayName;
  final String? email;

  const UserInfoPayload({
    required this.userId,
    required this.displayName,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'email': email,
    };
  }
}
