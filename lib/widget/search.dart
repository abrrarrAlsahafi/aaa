import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final onSearchTextChanged;
  final controller;
  final onPressed;

  const SearchWidget({Key key, this.onSearchTextChanged, this.controller, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child:ListTile(
        leading: new Icon(Icons.search),
        title: new TextField(
          controller: controller,
          decoration: new InputDecoration(
              hintText: 'Search', border: InputBorder.none),
          onChanged: onSearchTextChanged,
        ),
        trailing: new IconButton(
          icon: new Icon(Icons.close),
          onPressed:onPressed
        ),
      )
    );
  }
}
