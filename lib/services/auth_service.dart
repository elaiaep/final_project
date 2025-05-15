import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String pass) async {
    return (await _auth.signInWithEmailAndPassword(email: email, password: pass)).user;
  }
  Future<User?> register(String email, String pass) async {
    return (await _auth.createUserWithEmailAndPassword(email: email, password: pass)).user;
  }
  Future<User?> signInWithGoogle() async {
    final gu = await GoogleSignIn().signIn();
    if (gu == null) return null;
    final ga = await gu.authentication;
    final cred = GoogleAuthProvider.credential(accessToken: ga.accessToken, idToken: ga.idToken);
    return (await _auth.signInWithCredential(cred)).user;
  }
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }
}