import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:onepass/services/data.dart' as data;

FirebaseAuth _auth = FirebaseAuth.instance;

Future<User> signUpEmailAndPassword(String email, String password) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = userCredential.user;
    print("auth:" + user.email);
    return user;
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future<User> getCurrentUser() async {
  return await _auth.currentUser;
}

Future<DocumentSnapshot> signInEmailAndPassword(
    String email, String password) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = userCredential.user;
    final docSnap = await data.getUserFromId(user.uid);
    debugPrint(docSnap.data().toString());
    return docSnap;
  } catch (e) {
    print("auth:");
    print(e.toString());
    return null;
  }
}

Future<bool> signOut() async {
  try {
    await _auth.currentUser.delete().then((value) => () {
          return true;
        });
  } catch (e) {
    return false;
  }
}
