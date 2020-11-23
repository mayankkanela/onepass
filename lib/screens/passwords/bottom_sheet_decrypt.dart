import 'package:flutter/cupertino.dart';
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
    bool _isObscured = true;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: dh * 1, horizontal: dw * 2),
          width: double.maxFinite,
          child: Text(
            account.nickName,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: dh * 2),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(dh * 4),
            ),
          ),
        ),
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: dw * 2.4, vertical: dh * 1),
          margin: EdgeInsets.symmetric(vertical: dh * 2, horizontal: dw * 4),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.8),
              borderRadius: BorderRadius.circular(dh * 4)),
          child: Text(
            account.hash,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: dh * 2),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: dw * 4, vertical: dh * 2),
          padding: EdgeInsets.symmetric(vertical: dh * 3, horizontal: dw * 4),
          width: double.maxFinite,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                const Color(0xffe6e6e6),
                Colors.white,
              ], begin: Alignment(-5, -5), end: Alignment(1, 1)),
              borderRadius: BorderRadius.circular(dh * 4),
              boxShadow: [
                BoxShadow(
                    color: Color(0xffd9d9d9),
                    offset: Offset(dh * 1, dh * 1),
                    blurRadius: dh * 0.5),
                BoxShadow(
                    color: Colors.white,
                    offset: Offset(dh * -1, dh * -1),
                    blurRadius: dh * 0.5),
              ]),
          child: Text(
            _isObscured ? '*' * 5 : 'ds',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }
}
