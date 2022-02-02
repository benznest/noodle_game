
import 'package:firebase_auth/firebase_auth.dart';

class MyFirebaseAuthManager {
  static FirebaseAuth? _auth;

  static init() async {
    _auth = FirebaseAuth.instance;
    _auth?.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  static User? get currentUser {
    return _auth?.currentUser;
  }

  static reload() async {
    return await _auth?.currentUser?.reload();
  }

  static bool get isSignedIn {
    return _auth?.currentUser != null;
  }

  static signOut() async {
    await _auth?.signOut();
  }

  static Future<UserCredential> loginWithFacebook() async {
    FacebookAuthProvider facebookProvider = FacebookAuthProvider();

    facebookProvider.addScope('email');
    facebookProvider.addScope('public_profile');
    facebookProvider.setCustomParameters({
      'display': 'popup',
    });

    return await FirebaseAuth.instance.signInWithPopup(facebookProvider);
  }
}