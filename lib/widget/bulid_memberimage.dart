import 'dart:convert';

import 'package:flutter/material.dart';

class MembertImage extends StatelessWidget {
  final index;
  final image;

  const MembertImage({Key key, this.index, this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return buildImage(index, image);
  }

  buildImage(index, image) {
    if (image == 'False') {
      return Image.asset(
        'assets/images/iodoo.png',
        fit: BoxFit.cover,
        height: 44,
        width: 44,
      );
      /* Icon(
        Icons.person,
        size: 33,
      );*/
    } else {
      var str = image.toString().substring(2, image.toString().length - 1);
      str = base64.normalize(str);
      return Image.memory(
        base64.decode(str),
        fit: BoxFit.cover,
        height: 44,
        width: 44,
      );
    }
  }
}
