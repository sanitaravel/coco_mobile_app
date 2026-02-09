import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    // ensure we have a user profile in Firestore
    await _ensureUserProfile(cred.user);
    return cred;
  }

  Future<UserCredential> signUp(String firstName, String lastName, String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    // update display name
    final displayName = '${firstName.trim()} ${lastName.trim()}'.trim();
    if (displayName.isNotEmpty) {
      await cred.user?.updateDisplayName(displayName);
    }
    // create Firestore user profile
    await _ensureUserProfile(cred.user);
    return cred;
  }

  Future<void> _ensureUserProfile(User? user) async {
    if (user == null) return;
    final users = FirebaseFirestore.instance.collection('users');
    final doc = users.doc(user.uid);
    final snapshot = await doc.get();
    final now = FieldValue.serverTimestamp();
    final data = {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'lastSignIn': now,
    };
    if (snapshot.exists) {
      await doc.update({'lastSignIn': now, 'email': user.email});
    } else {
      await doc.set({...data, 'createdAt': now});
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
