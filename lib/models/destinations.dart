import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Destination {
  const Destination(
    this.title,
    this.icon,
  );
  final String title;
  final IconData icon;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Vault', Icons.shield),
  Destination(
    'Generate',
    Icons.add,
  ),
];
