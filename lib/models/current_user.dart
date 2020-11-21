import 'package:flutter/cupertino.dart';

class CurrentUser {
  final String userId;
  final String email;

  CurrentUser({
    @required this.userId,
    @required this.email,
  });

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    if (json != null)
      return CurrentUser(
        userId: json["userId"],
        email: json["email"],
      );
    return null;
  }
}
