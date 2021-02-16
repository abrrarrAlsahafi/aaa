import 'package:flutter/material.dart';
import 'dart:core';

import 'package:management_app/services/emom_api.dart';

class Massege {
  var text;
  var sender;
  DateTime date;
  var idSender;
  bool isMine;

  Massege(this.text, this.date, this.sender, this.isMine);
  Massege.fromJson(Map<String, dynamic> json) {
    //print('date ${json['message_date']}');
    date =DateTime.parse( json['message_date']);
    text = json['message_body'];
    sender = json['message_sender'];
    idSender = json['sender_id'];
    isMine = json['is_mine'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message_date'] = this.date;
    data['message_body'] = this.text;
    data['message_sender'] = this.sender;
    data['sender_id'] = this.idSender;
    data['is_mine'] = this.isMine;
    return data;
  }
}

class MassegesContent extends ChangeNotifier {
  bool isNewMassege=false;
  List massegesContent;
 // Massege massege;//= massegesContent.last;


  MassegesContent();
  get masseges=>massegesContent.last;
  getMassegesContent(mid) async {
    massegesContent=await EmomApi().getMassegesContent(mid);
    //isNewMassege=true;
  //  massege =  massegesContent.last;
   return massegesContent; //await EmomApi().getMassegesContent(mid);
  }

}

class NewMessagesModel extends ChangeNotifier {
  NewMessages newMessages;
  NewMessagesModel();
  newMessagesList() async {
    newMessages = await EmomApi().newMasseges();
    // print(newMessages.totalNewMessages);
    return newMessages;
  }
}

class NewMessages {
  int totalNewMessages;
  List<ChannelMessages> channelMessages;

  NewMessages({this.totalNewMessages, this.channelMessages});

  NewMessages.fromJson(Map<String, dynamic> json) {
    // print('${json['total_new_messages'].runtimeType}');
    totalNewMessages =
        json['total_new_messages']; //int.parse(json['total_new_messages']);
    if (json['channel_messages'] != null) {
      channelMessages = new List<ChannelMessages>();
      json['channel_messages'].forEach((v) {
        channelMessages.add(new ChannelMessages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_new_messages'] = this.totalNewMessages;
    if (this.channelMessages != null) {
      data['channel_messages'] =
          this.channelMessages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChannelMessages {
  int channelId;
  int newMessages;
  String channelName;
  String image;
  String lastMessage;
  String lastDate;
  bool isChat;

  ChannelMessages(
      {this.channelId,
      this.newMessages,
      this.channelName,
      this.image,
      this.lastMessage,
      this.lastDate,
      this.isChat});

  ChannelMessages.fromJson(Map<String, dynamic> json) {
    channelId = json['channel_id'];
    newMessages = json['new_messages'];
    channelName = json['channel_name'];
    image = json['image'];
    lastMessage = json['last_message'];
    lastDate = json['last_date'];
    isChat = json['is_chat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channel_id'] = this.channelId;
    data['new_messages'] = this.newMessages;
    data['channel_name'] = this.channelName;
    data['image'] = this.image;
    data['last_message'] = this.lastMessage;
    data['last_date'] = this.lastDate;
    data['is_chat'] = this.isChat;
    return data;
  }
}
