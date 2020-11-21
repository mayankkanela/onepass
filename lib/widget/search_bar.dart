import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 2.8),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 5),
          suffixIcon: Icon(
            Icons.search,
            size: .8,
            color: Colors.black,
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(3))),
    );
  }
}
