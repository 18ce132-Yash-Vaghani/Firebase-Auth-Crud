// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get onAuthStateChanged => _firebaseAuth.authStateChanges();

  Future<void> signout() async {
    FirebaseAuth.instance.signOut();
    User user = _firebaseAuth.currentUser;
    print("uid: " + user.uid);
    if (user != null) {
      print("User logged Out");
    }
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed In";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed Up";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }
}
