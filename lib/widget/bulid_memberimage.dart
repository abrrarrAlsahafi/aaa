import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:management_app/app_theme.dart';
import 'package:management_app/model/folowing.dart';
import 'package:management_app/model/user.dart';

class MembertImage extends StatelessWidget {
  final item;

  const MembertImage({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  buildImage( item);
  }
  buildImage( item) {
    if(item.runtimeType==Folowing){
      var str = item.image.toString().substring(2,item.image.toString().length - 1);
      str = base64.normalize(str);
      return Container(
          width:50,
          height: 50,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: Image.memory(
                    base64.decode(str),
                    fit: BoxFit.cover,
                    height: 44,
                    width: 44,
                  ).image,
                  fit: BoxFit.fill
              ),
          shape: BoxShape.circle),
      );
    }else{
    if (item.image == 'False') {
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
         //border: BoxBorder.,
          shape: BoxShape.circle,
         border: Border.all(color: Colors.white),
          image: DecorationImage(
              image:Image.asset(
                'assets/images/iodoo.png',
                fit: BoxFit.cover,
              ).image,// NetworkImage('https://googleflutter.com/sample_image.jpg'),
             // fit: BoxFit.fill
          ),
        ),
      );
    }
    if(item.isChat){
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: MyTheme.kPrimaryColorVariant),
         color:MyTheme.kPrimaryColorVariant ,
          shape: BoxShape.circle,
        ),
        child:  Icon(
          item.isChat?Icons.person:Icons.group_outlined,
          color: Colors.white,
          size: 33,
        ),
      );
    } else {
      var str = item.image.toString().substring(2,item.image.toString().length - 1);
      str = base64.normalize(str);
      return Container(
        width:50,
        height: 50,
        decoration: BoxDecoration(
         // boxShadow: BoxShadow(color: Colors.white),
          border: Border.all(color:Colors.white),
          shape: BoxShape.circle,
          image: DecorationImage(
              image: Image.memory(
                base64.decode(str),
                fit: BoxFit.cover,
                height: 44,
                width: 44,
              ).image,
              fit: BoxFit.fill
          ),
        ),
      );

    }}
  }
}
