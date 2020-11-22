import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:onepass/services/auth.dart' as Auth;
import 'package:onepass/utils/constants.dart';

FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

Future<DocumentSnapshot> completeSignUp(String email, String password) async {
  final user = await Auth.signUpEmailAndPassword(email, password);
  if (user != null) {
    final Map<String, dynamic> data = {"userId": user.uid, "email": email};
    await _firebaseFirestore
        .collection(Constants.USERS)
        .doc(user.uid)
        .set(data)
        .then((value) => debugPrint("user added"));
    final DocumentSnapshot result = await _firebaseFirestore
        .collection(Constants.USERS)
        .doc(user.uid)
        .get();

    return result;
  }
  return null;
}

Future<DocumentSnapshot> getUserFromId(String docId) async {
  final DocumentSnapshot result =
      await _firebaseFirestore.collection(Constants.USERS).doc(docId).get();
  debugPrint(result.data().toString());
  return result;
}

Future<DocumentSnapshot> updateUser(Map<String, dynamic> data) async {
  final user = await Auth.getCurrentUser();

  if (user != null) {
    await _firebaseFirestore
        .collection(Constants.USERS)
        .doc(user.uid)
        .update(data);
    final DocumentSnapshot docSnap = await _firebaseFirestore
        .collection(Constants.USERS)
        .doc(user.uid)
        .get();
    debugPrint(docSnap.data().toString());
    return docSnap;
  }
  return null;
}

Future<DocumentSnapshot> getAccounts(String userId) async {
  final user = await Auth.getCurrentUser();
  if (user != null) {
    final DocumentSnapshot result = await _firebaseFirestore
        .collection(Constants.ACCOUNTS)
        .doc(user.uid)
        .get();
    debugPrint(result.data().toString());
    return result;
  }
  return null;
}

Future<DocumentSnapshot> addAccount(Map<String, dynamic> data) async {
  final user = await Auth.getCurrentUser();
  if (user != null) {
    try {
      await _firebaseFirestore
          .collection(Constants.ACCOUNTS)
          .doc(user.uid)
          .set({
        'accounts': FieldValue.arrayUnion([data])
      }, SetOptions(merge: true));
      final DocumentSnapshot result = await _firebaseFirestore
          .collection(Constants.ACCOUNTS)
          .doc(user.uid)
          .get();
      debugPrint(result.data().toString());
      return result;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
  return null;
}
