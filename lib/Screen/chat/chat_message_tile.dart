import 'dart:core';

import 'package:management_app/common/constant.dart';
import 'package:management_app/model/massege.dart';
import 'package:management_app/model/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../bottom_bar.dart';

//import '../../common/messages.dart';

class MyMessageChatTile extends StatelessWidget {
  final double minValue = 10.0;
  final sender;
  final Massege message;
  final currentUser;
  final userImage;
  final bool isCurrentUser;
  final msender;
  final DateTime datesend;
  final isChat;

  MyMessageChatTile(
      {this.message,
      this.isCurrentUser,
      this.userImage,
      this.sender,
      this.currentUser,
      this.msender,
      this.datesend, this.isChat});
  @override
  Widget build(BuildContext context) {
    final cap =
        Theme.of(context).textTheme.subhead.apply(color: Colors.black87);
    final tit = Theme.of(context).textTheme.caption.apply(color: Colors.white54);

    return Align(
          alignment: (isCurrentUser?Alignment.topRight:Alignment.topLeft),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 7,
                  offset: Offset(0.4,0.3),
                  color: Colors.black26
                )
              ],
              borderRadius: isCurrentUser
            ? BorderRadius.only(
                topRight:Radius.zero ,
            topLeft: Radius.circular(minValue * 2),
            bottomLeft: Radius.circular(minValue * 2),
            bottomRight: Radius.circular(minValue * 2),
          )
                : BorderRadius.only(
        bottomRight: Radius.circular(minValue * 2),
          bottomLeft: Radius.circular(minValue * 2),
          topRight: Radius.circular(minValue * 2)),
        color: isCurrentUser ? hexToColor('#E1E8F5') : Colors.white,
            ),
            padding: EdgeInsets.all(6),
            child: Stack(children:[
            Padding(padding: EdgeInsets.all(10),
                child: Text.rich(builder())),
              Positioned(child: Text('${DateFormat.jm().format(datesend).toString()}',
                  style: TextStyle(
                      fontSize: 9, color: Colors.grey),
              ), right: 6.0,
                bottom: 0.0,
              )
            ]),
            margin: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
          ),
      );
  }

  TextSpan builder(){
    return TextSpan(
        style: TextStyle(fontSize: 15),
      children: [
        isChat?TextSpan(text:''):TextSpan(text:"${msender.toString().trim()}\n"),
        TextSpan(text:"${message.text.toString().trim()}\n"),
      ]
    );

  }
}
