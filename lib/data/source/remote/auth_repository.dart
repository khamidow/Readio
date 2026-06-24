import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../local/my_pref.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<void> initialize() async {
    await _googleSignIn.initialize(
      serverClientId:
          '79677877298-a3juvcv2t0o14nte25dut0ttjttu489c.apps.googleusercontent.com',
    );
  }

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      MyPref.setText("PASSWORD", googleUser.id);
      MyPref.setText("USERNAME", googleUser.email);
      MyPref.setText("GOOGLE_AUTH", "true");
      return true;
    } catch (e) {
      print('Google Sign-In Error: $e');
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      MyPref.setText("PASSWORD", password);
      MyPref.setText("USERNAME", email);
      MyPref.setText("GOOGLE_AUTH", "NULL");
      return true;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      MyPref.setText("PASSWORD", password);
      MyPref.setText("USERNAME", email);
      MyPref.setText("GOOGLE_AUTH", "NULL");
      return true;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return false;
    }
  }

  Future<void> log_out() async {
    if (MyPref.getText("GOOGLE_AUTH") == "true") {
      MyPref.setText("PASSWORD", "NULL");
      MyPref.setText("USERNAME", "NULL");
      MyPref.setText("GOOGLE_AUTH", "NULL");
      await _googleSignIn.signOut();
      await _auth.signOut();
    } else {
      try {
        MyPref.setText("PASSWORD", "NULL");
        MyPref.setText("USERNAME", "NULL");
        MyPref.setText("GOOGLE_AUTH", "NULL");
        await _auth.signOut();
      } catch (e) {
        print("Sign-out error: ${e.toString()}");
      }
    }
  }

  Future<String?> currentUser() async {
    return _auth.currentUser?.email.toString();
  }

  Future<bool> unregister() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email ?? "NULL",
          password: MyPref.getText("PASSWORD"),
        );
        await user.reauthenticateWithCredential(credential);
        await user.delete();

        MyPref.setText("PASSWORD", "NULL");
        MyPref.setText("USERNAME", "NULL");
        return true;
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    }
    return false;
  }

  // Map<String, dynamic> users = jsonDecode(
  //   MyPref.getText("USERS") == "NULL" ? "{}" : MyPref.getText("USERS"),
  // );

  // bool register(String name, String password) {
  //   if (users[name] != null) {
  //     return false;
  //   } else {
  //     users[name] = password;
  //     MyPref.setText("logged_name", name);
  //     updateChanges();
  //     return true;
  //   }
  // }
  //
  // bool login(String name, String password) {
  //   if (users[name] == password) {
  //     MyPref.setText("logged_name", name);
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // bool log_out() {
  //   MyPref.setText("logged_name", "NULL");
  //   return true;
  // }

  // Future<bool> unregister() async {
  //   users.remove(MyPref.getText("logged_name"));
  //   MyPref.setText("logged_name", "NULL");
  //   await updateChanges();
  //   return true;
  // }

  // Future<bool> updateChanges() async {
  //   return await MyPref.setText("USERS", jsonEncode(users));
  // }
  //
  // Map<String, dynamic> getChanges() {
  //   return jsonDecode(
  //     MyPref.getText("USERS") == "NULL" ? "{}" : MyPref.getText("USERS"),
  //   );
  // }

  void _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        print('Error: The password provided is too weak.');
        break;
      case 'email-already-in-use':
        print('Error: An account already exists for that email.');
        break;
      case 'user-not-found':
        print('Error: No user found for that email.');
        break;
      case 'wrong-password':
        print('Error: Wrong password provided.');
        break;
      case 'invalid-email':
        print('Error: The email address form is malformed.');
        break;
      default:
        print('Error: Auth Error: ${e.message}');
    }
  }
}
