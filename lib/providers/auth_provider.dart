import 'package:field_flow/db/firestore_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreHelper _firestoreHelper;

  AuthProvider({required FirestoreHelper firestoreHelper})
      : _firestoreHelper = firestoreHelper;

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
            serverClientId:
                "995776545775-3uiro9i0ur67si8onnfagjbohr4lf9tr.apps.googleusercontent.com")
        .signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user != null) {
      final userDoc = await _firestoreHelper.getUser(user.uid);
      if (!userDoc.exists) {
        await _firestoreHelper.createUser(
            user.uid, user.displayName, user.email);
      }
    }
    return user;
  }
}
