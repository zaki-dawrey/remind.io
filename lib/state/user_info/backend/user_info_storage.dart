import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:reminder/state/constants/firebase_collection_name.dart';
import 'package:reminder/state/constants/firebase_field_name.dart';
import 'package:reminder/state/constants/typedefs/user_id.dart';
import 'package:reminder/state/user_info/models/user_info_payload.dart';

@immutable
class UserInfoStorage {
  const UserInfoStorage();

  Future<bool> saveUserInfo({
    required UserId userId,
    required String displayName,
    required String? email,
  }) async {
    try {
      final userInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(userId)
          .get();

      if (userInfo.exists) {
        await userInfo.reference.update({
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email ?? '',
        });
      } else {
        final payload = UserInfoPayload(
          userId: userId,
          displayName: displayName,
          email: email,
        );
        await FirebaseFirestore.instance
            .collection(FirebaseCollectionName.users)
            .doc(userId)
            .set(payload.toJson());
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
