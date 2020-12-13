import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onepass/utils/utility.dart' as Utils;

class Generator extends StatefulWidget {
  @override
  _GeneratorState createState() => _GeneratorState();
}

class _GeneratorState extends State<Generator> {
  double _sliderValue = 8;
  bool _isInit;
  String _password;
  @override
  void initState() {
    _isInit = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double dw = Utils.displayWidth(context) / 100;
    double dh = Utils.displayHeight(context) / 100;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(dh, dw),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_isInit ? 'MOVE THE SLIDER' : _password),
            Container(
              padding: EdgeInsets.symmetric(horizontal: dw * 4),
              child: Slider(
                onChanged: (double value) {
                  debugPrint(_sliderValue.toString());
                  setState(() {
                    if (_isInit) _isInit = false;
                    _sliderValue = value;
                    _password = Utils.generate(_sliderValue.toInt());
                  });
                },
                value: _sliderValue,
                min: 8,
                max: 30,
                divisions: 200,
                label: _sliderValue.truncate().toString(),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(dh * 2),
                  border: Border.all(color: Colors.grey)),
              margin:
                  EdgeInsets.symmetric(vertical: dh * 1, horizontal: dw * 10),
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: dh * 2),
                onPressed: () => _copyItem(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.copy), Text('TAP TO COPY')],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(double dh, double dw) {
    return AppBar(
      toolbarHeight: kToolbarHeight + dh * 5,
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      title: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
                padding:
                    EdgeInsets.symmetric(vertical: dh * 2, horizontal: dw * 2),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      const Color(0xffe6e6e6),
                      Colors.white,
                    ], begin: Alignment(-5, -5), end: Alignment(1, 1)),
                    borderRadius: BorderRadius.circular(dh * 1),
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
                child: Text('Generate Password',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey))),
          ),
        ],
      ),
    );
  }

  _copyItem() async {
    if (!Utils.isNullOrEmpty(_password))
      await Clipboard.setData(ClipboardData(text: _password)).then((value) {
        final snackBar = SnackBar(
          content: Text('Copied to Clipboard'),
          duration: Duration(seconds: 1),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      });
    else {
      final snackBar = SnackBar(
        content: Text('Generate Password First!'),
        duration: Duration(seconds: 1),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}
