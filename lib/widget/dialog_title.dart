import 'package:flutter/material.dart';

class DialogTitle extends StatelessWidget {
  final String title;
  final double dh;
  final double dw;
  const DialogTitle({
    Key key,
    this.title = 'Title?',
    @required this.dh,
    @required this.dw,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: dh * 0.5),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(dh * 4),
              topLeft: Radius.circular(dh * 4))),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontSize: dh * 3, fontWeight: FontWeight.bold),
      ),
    );
  }
}
