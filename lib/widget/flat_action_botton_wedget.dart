import 'package:flutter/material.dart';

class FlatActionButtonWidget extends StatelessWidget {
  final onPressed;
  final tooltip;
  final icon;

  const FlatActionButtonWidget({Key key, this.onPressed, this.tooltip, this.icon}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return  FloatingActionButton(
      backgroundColor: Color(0xffe9a14e),
      onPressed: onPressed,
      tooltip: tooltip,

      child: Icon(
        icon,
       // Icons.add,
        color: Colors.white,
      ),
    );
  }
}
