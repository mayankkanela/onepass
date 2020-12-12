import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:onepass/utils/utility.dart' as Utils;

class Generator extends StatefulWidget {
  @override
  _GeneratorState createState() => _GeneratorState();
}

class _GeneratorState extends State<Generator> {
  double _sliderValue = 8;
  bool _isInit;
  @override
  void initState() {
    debugPrint('here');
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
            Text(_isInit
                ? 'MOVE THE SLIDER'
                : Utils.generate(_sliderValue.toInt())),
            Container(
              padding: EdgeInsets.symmetric(horizontal: dw * 4),
              child: Slider(
                onChanged: (double value) {
                  debugPrint(_sliderValue.toString());
                  setState(() {
                    if (_isInit) _isInit = false;
                    _sliderValue = value;
                  });
                },
                value: _sliderValue,
                min: 8,
                max: 30,
                divisions: 200,
                label: _sliderValue.truncate().toString(),
              ),
            ),
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
}
