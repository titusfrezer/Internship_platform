import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'Intern/Utilities/variables.dart';
import 'model/eventItem.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String> get onAuthStateChanged =>
      _firebaseAuth.onAuthStateChanged.map(
            (FirebaseUser user) => user.uid,
      );


  // Sign Out
  signOut() async {
    await _firebaseAuth.signOut();
  }

  currentUser() {
    _firebaseAuth.currentUser();
  }
}