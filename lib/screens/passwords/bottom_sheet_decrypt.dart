import 'package:flutter/material.dart';
import 'package:onepass/models/account.dart';

class BottomSheetDecrypt extends StatelessWidget {
  final double dw;
  final double dh;
  final Account account;
  const BottomSheetDecrypt({
    Key key,
    this.dw,
    this.dh,
    this.account,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: Text(account.nickName),
        ),
        SizedBox(
          height: dh * 10,
        )
      ],
    );
  }
}
