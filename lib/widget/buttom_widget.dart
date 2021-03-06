import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final onPressed;
  final child;

   ButtonWidget({Key key, this.onPressed, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      width: 500.0,

      padding: EdgeInsets.all(12.0),
      child: RaisedButton(
        textColor: Colors.white,
        color: Color(0xff336699),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
