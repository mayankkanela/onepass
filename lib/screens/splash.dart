import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:onepass/providers/user_provider.dart';
import 'package:onepass/utils/constants.dart';
import 'package:onepass/utils/utility.dart' as Utils;
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dw = Utils.displayWidth(context) / 100;
    final dh = Utils.displayHeight(context) / 100;
    return Scaffold(
      body: Center(
        child: Text(
          "OnePass",
          style: TextStyle(
              fontSize: dh * 5,
              color: Colors.blue,
              fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  _getUser() async {
    final val = await Provider.of<UserProvider>(context, listen: false)
        .getCurrentUser();
    if (val) {
      //todo check if user is joined in a classroom and populate data
      Navigator.of(context).pushReplacementNamed(Constants.ROUTE_HOME);
    } else {
      Navigator.of(context).pushReplacementNamed(Constants.ROUTE_SIGN_UP);
    }
  }
}
