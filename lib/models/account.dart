import 'package:flutter/cupertino.dart';

class Account {
  final String hash;
  final String nickName;

  Account({@required this.hash, @required this.nickName});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      hash: json["hash"],
      nickName: json["nickName"],
    );
  }

  Map<String, dynamic> toJson(Account instance) =>
      <String, dynamic>{"hash": instance.hash, "nickName": instance.nickName};
}
