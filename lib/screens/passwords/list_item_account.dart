import 'package:flutter/material.dart';
import 'package:onepass/models/account.dart';

class ListItemAccount extends StatelessWidget {
  final Account account;
  final double dh;
  final double dw;
  final Function _decryptBottomSheet;
  ListItemAccount(this.account, this.dw, this.dh, this._decryptBottomSheet);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _decryptBottomSheet(account, dw, dh),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: dw * 4, vertical: dh * 2),
        padding: EdgeInsets.symmetric(vertical: dh * 3, horizontal: dw * 4),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              const Color(0xffe6e6e6),
              Colors.white,
            ], begin: Alignment(-5, -5), end: Alignment(1, 1)),
            borderRadius: BorderRadius.circular(dh * 4),
            boxShadow: [
              BoxShadow(
                  color: Color(0xffd9d9d9),
                  offset: Offset(dh * 0.6, dh * 0.6),
                  blurRadius: dh * 0.5),
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(dh * -1, dh * -1),
                  blurRadius: dh * 0.5),
            ]),
        child: Row(
          children: [
            Flexible(
              child: Text(
                account.nickName,
                style:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: dh * 2.8),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
