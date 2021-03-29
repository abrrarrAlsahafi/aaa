import 'package:flutter/material.dart';
class SubTitelWidget extends StatelessWidget {
  final child;
  final title;

  const SubTitelWidget({Key key, this.child, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(

        children: [
          child,
         SizedBox(width: 12,),
      Text(title),
    ]);
  }
}
