import 'package:flutter/material.dart';
import 'package:onepass/screens/passwords.dart';

import 'generator.dart';

class DestinationView extends StatefulWidget {
  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              debugPrint(settings.name);
              switch (settings.name) {
                case '/':
                  return Passwords();
                case '/generator':
                  return Generator();
                default:
                  return Center(
                    child: Text('no route defined'),
                  );
              }
            });
      },
    );
  }
}
