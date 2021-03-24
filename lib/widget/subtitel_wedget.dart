import 'package:flutter/material.dart';

import '../app_theme.dart';
import 'content_translate.dart';

class SubTitelWidjet extends StatelessWidget {
  final code;
  final titl;

  const SubTitelWidjet({Key key, this.code, this.titl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      ContentApp(
        code: code,
        style: MyTheme.bodyText2,
      ),
      Text(titl),
    ]);
  }
}
