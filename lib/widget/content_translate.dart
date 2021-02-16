
import 'package:flutter/material.dart';
import 'package:management_app/generated/I10n.dart';

class ContentApp extends StatelessWidget {
  ContentApp({this.index,this.code,this.style,this.align});
  final TextStyle style;
  final int index;
  final String code;
  final TextAlign align;


  @override
  Widget build(BuildContext context) {
   return Text(
        S.of(context).translate(code + '${index==null?'':index}'),
        style:style,
        textAlign: align,
      );
  }
}
