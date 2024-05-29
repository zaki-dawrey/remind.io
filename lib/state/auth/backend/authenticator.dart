import 'package:firebase_auth/firebase_auth.dart';
import 'package:reminder/state/auth/notifiers/models/auth_result.dart';
import 'package:reminder/state/constants/typedefs/user_id.dart';
import 'package:reminder/state/user_info/backend/user_info_storage.dart';

class Authenticator {
  const Authenticator();
  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;
  bool get isAlreadyLoggedIn => userId != null;
  String get displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? '';
  String? get email => FirebaseAuth.instance.currentUser?.email;

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<AuthResult> loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult.success;
    } on FirebaseAuthException {
      return AuthResult.failure;
    }
  }

  Future<AuthResult> signUpWithEmail(
      String email, String password, String displayName) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(displayName);
      const userInfoStorage = UserInfoStorage();
      await userInfoStorage.saveUserInfo(
        userId: userCredential.user!.uid,
        displayName: displayName,
        email: email,
      );

      return AuthResult.success;
    } catch (e) {
      return AuthResult.failure;
    }
  }
}
