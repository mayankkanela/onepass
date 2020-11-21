import 'package:flutter/cupertino.dart';
import 'package:onepass/models/accounts.dart';
import 'package:onepass/models/current_user.dart';
import 'package:onepass/services/auth.dart' as Auth;
import 'package:onepass/services/data.dart' as Data;

class UserProvider with ChangeNotifier {
  static CurrentUser _currentUser;
  static List<Account> _accounts = [];

  List<Account> get accounts {
    return _accounts;
  }

  Future<bool> signIn(String email, String password) async {
    final docSnapShot = await Auth.signInEmailAndPassword(email, password);

    if (docSnapShot != null && docSnapShot.exists) {
      _currentUser = CurrentUser.fromJson(docSnapShot.data());
      return true;
    }
    return false;
  }

  Future<bool> signUp(String email, String password) async {
    final documentSnapShot = await Data.completeSignUp(email, password);
    if (documentSnapShot != null && documentSnapShot.exists) {
      _currentUser = CurrentUser.fromJson(documentSnapShot.data());
      return true;
    }
    return false;
  }

  Future<bool> getCurrentUser() async {
    final user = await Auth.getCurrentUser();

    if (user != null) {
      final docSnap = await Data.getUserFromId(user.uid);
      if (docSnap != null && docSnap.exists) {
        _currentUser = CurrentUser.fromJson(docSnap.data());
        return true;
      }
    }
    return false;
  }

  Future<bool> updateUser(Map<String, dynamic> data) async {
    final user = await Auth.getCurrentUser();
    if (user != null) {
      final docSnap = await Data.updateUser(data);
      if (docSnap != null && docSnap.exists) {
        _currentUser = CurrentUser.fromJson(docSnap.data());
        return true;
      }
    }
    return false;
  }
}
