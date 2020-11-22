import 'package:encrypt/encrypt.dart' as en;
import 'package:flutter/material.dart';
import 'package:onepass/models/destinations.dart';
import 'package:onepass/utils/utility.dart' as Utils;

import 'file:///E:/projects/onepass/lib/screens/passwords/passwords.dart';

import 'generator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _keyController = new TextEditingController();
  final _secretController = new TextEditingController();
  int _currentIndex = 0;
  String _decrypted;
  en.Encrypted _encrypted;
  final _screens = [Passwords(), Generator()];
  final _pageController = new PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    final dw = Utils.displayWidth(context) / 100;
    final dh = Utils.displayHeight(context) / 100;
    return SafeArea(
        child: Scaffold(
      // body: Container(
      //   margin: EdgeInsets.all(dw * 4),
      //   child: Column(
      //     children: [
      //       TextFormField(
      //         controller: _keyController,
      //         obscureText: true,
      //         decoration: InputDecoration(labelText: "Enter secret key"),
      //       ),
      //       TextFormField(
      //         controller: _secretController,
      //         decoration: InputDecoration(labelText: "Enter secret message"),
      //       ),
      //       FlatButton(
      //         onPressed: () => _encrypt(),
      //         child: Text(
      //           "Encrypt",
      //           style: TextStyle(color: Colors.white),
      //         ),
      //         color: Colors.blue,
      //       ),
      //       Text("Encrypted text:" + (_encrypted?.base64 ?? ' ')),
      //       FlatButton(
      //         onPressed: () => _decrypt(),
      //         child: Text(
      //           "Decrypt",
      //           style: TextStyle(color: Colors.white),
      //         ),
      //         color: Colors.blue,
      //       ),
      //       Text("Decrypted text:" + (_decrypted ?? ' ')),
      //     ],
      //   ),
      // ),
      body: PageView.builder(
        itemCount: 2,
        controller: _pageController,
        onPageChanged: (index) => _switchBottomIcon(index),
        itemBuilder: (BuildContext context, int index) {
          return _screens[index];
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(dw, dh),
    ));
  }

  BottomNavigationBar _buildBottomNavigationBar(double dw, double dh) {
    return BottomNavigationBar(
      elevation: dh * 2,
      currentIndex: _currentIndex,
      showUnselectedLabels: false,
      selectedLabelStyle: TextStyle(color: Colors.white),
      onTap: (index) => _switch(index),
      items: allDestinations
          .map(
            (e) => BottomNavigationBarItem(
              icon: Icon(
                e.icon,
              ),
              label: e.title,
            ),
          )
          .toList(),
    );
  }

  _encrypt() {
    setState(() {
      _encrypted = Utils.encrypt(_secretController.text, _keyController.text);
    });
  }

  _decrypt() {
    setState(() {
      _decrypted = Utils.decrypt(_encrypted.base64, _keyController.text);
    });
  }

  _switch(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 150), curve: Curves.ease);
  }

  _switchBottomIcon(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
