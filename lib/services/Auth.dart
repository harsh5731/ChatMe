import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/models/user.dart';


class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User1 _userFromFirebaseUser(User user2) {
    return user2 != null ? User1(uid: user2.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user2 = result.user;
      return _userFromFirebaseUser(user2);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user2 = result.user;
      return _userFromFirebaseUser(user2);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

}